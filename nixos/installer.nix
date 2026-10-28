# A thin install ISO: nixpkgs' minimal installer plus ./portable.nix, with flakes,
# NetworkManager on iwd and the tools to install, disko-install included. No host closure: an
# install fetches its store paths from substituters. The consumer adds its keys, caches and
# flake source. Build it with config.system.build.isoImage.
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  cfg = config.nixentials.installer;
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./portable.nix
  ];

  options.nixentials.installer.user = lib.mkOption {
    type = lib.types.str;
    default = "nixos";
    description = "The user the console logs in as. It gets an empty password and passwordless sudo; SSH takes keys only.";
  };

  config = {
    users.users.${cfg.user} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      initialHashedPassword = lib.mkForce "";
    };

    # The installer profile logs `nixos` in on the console.
    services.getty.autologinUser = lib.mkForce cfg.user;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # NetworkManager (./portable.nix) on iwd, in place of the installer's wpa_supplicant.
    networking.networkmanager.wifi.backend = "iwd";
    networking.wireless.iwd.enable = true;
    networking.wireless.enable = lib.mkForce false;

    security.sudo.wheelNeedsPassword = false;
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = lib.mkForce "no";

    # The install tools on top of ./portable.nix's disk tools
    environment.systemPackages = with pkgs; [
      disko
      git
      helix
      nixos-install-tools
      tmux
    ];

    # The installer can read ZFS pools, but the image itself never boots from one.
    boot.zfs.forceImportRoot = false;

    # The installer profile names the image itself, so only a force wins.
    image.baseName = lib.mkForce "installer";
    isoImage.makeEfiBootable = true;
    isoImage.makeUsbBootable = true;
  };
}
