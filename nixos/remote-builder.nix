# Distributed builds over SSH, both sides. A template: the hosts, users and keys are the
# consumer's.
#
# Client: every machine in `builders` becomes a nix.buildMachines entry, with its host key
# pinned and an SSH config that gives up quickly when the builder is offline. The nix
# daemon connects as root, so the client key is root's:
#   sudo ssh-keygen -t ed25519 -N "" -C nix-daemon@$(hostname) -f /root/.ssh/nix-builder
# Its public half goes into the builder's `server.clientKeys`.
#
# Server: `server.clientKeys` may log in as `server.user`, who becomes a trusted nix user, so
# the store accepts what the clients send.
{ config, lib, ... }:
let
  cfg = config.nixentials.remoteBuilder;
  inherit (lib) mkOption types;
in
{
  options.nixentials.remoteBuilder = {
    builders = mkOption {
      default = { };
      description = "Machines this host hands builds to, by name.";
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              hostName = mkOption {
                type = types.str;
                default = name;
                description = "Address of the builder.";
              };
              hostKey = mkOption {
                type = types.str;
                example = "ssh-ed25519 AAAAC3Nza...";
                description = "The builder's SSH host public key (/etc/ssh/ssh_host_ed25519_key.pub on it), pinned in known_hosts.";
              };
              sshUser = mkOption {
                type = types.str;
                description = "The user on the builder, its `server.user`.";
              };
              sshKey = mkOption {
                type = types.str;
                default = "/root/.ssh/nix-builder";
                description = "root's private key for the builder.";
              };
              systems = mkOption {
                type = types.listOf types.str;
                default = [ "x86_64-linux" ];
              };
              maxJobs = mkOption {
                type = types.int;
                default = 4;
              };
              speedFactor = mkOption {
                type = types.int;
                default = 1;
                description = "Preference among builders; higher gets builds first.";
              };
              supportedFeatures = mkOption {
                type = types.listOf types.str;
                default = [
                  "nixos-test"
                  "big-parallel"
                  "kvm"
                ];
              };
            };
          }
        )
      );
    };

    server = {
      enable = lib.mkEnableOption "builds for other machines over SSH";
      user = mkOption {
        type = types.str;
        description = "The user the clients log in as. It becomes a trusted nix user.";
      };
      clientKeys = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Public keys of the clients' /root/.ssh/nix-builder.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.builders != { }) {
      nix.distributedBuilds = true;
      # The builder fetches dependencies from the substituters itself instead of getting
      # them from this machine over SSH.
      nix.settings.builders-use-substitutes = true;

      nix.buildMachines = lib.mapAttrsToList (_: b: {
        inherit (b)
          hostName
          sshUser
          sshKey
          systems
          maxJobs
          speedFactor
          supportedFeatures
          ;
      }) cfg.builders;

      programs.ssh.knownHosts = lib.mapAttrs (_: b: {
        hostNames = [ b.hostName ];
        publicKey = b.hostKey;
      }) cfg.builders;

      # The daemon reads /etc/ssh/ssh_config. A short timeout and keepalives fail an offline
      # builder fast, since an unreachable builder can crash the nix daemon
      # (TunnelLogger::enqueueMsg abort).
      programs.ssh.extraConfig = lib.concatMapStrings (b: ''
        Host ${b.hostName}
          IdentityFile ${b.sshKey}
          IdentitiesOnly yes
          ConnectTimeout 5
          ServerAliveInterval 15
          ServerAliveCountMax 3
      '') (lib.attrValues cfg.builders);
    })

    (lib.mkIf cfg.server.enable {
      services.openssh.enable = true;
      nix.settings.trusted-users = [ cfg.server.user ];
      users.users.${cfg.server.user}.openssh.authorizedKeys.keys = cfg.server.clientKeys;
    })
  ];
}
