# A live ISO with the graphical session: nixpkgs' minimal installer plus ./session.nix and
# ./portable.nix. greetd logs `nixentials.rescue.user` straight into niri. The user's
# home-manager config is the consumer's; homeModules in this flake and the dms and niri-flake
# home modules give it the look. Build it with config.system.build.isoImage.
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  cfg = config.nixentials.rescue;
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./session.nix
    ./portable.nix
  ];

  options.nixentials.rescue.user = lib.mkOption {
    type = lib.types.str;
    default = "nixos";
    description = "The user the session logs in as. It gets an empty password and passwordless sudo.";
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

    # The first greetd session starts without a prompt. After a logout tuigreet asks again.
    services.greetd.settings.initial_session = {
      command = "niri-session";
      user = cfg.user;
    };

    # Forensics and recovery on top of ./portable.nix's disk tools: imaging, carving, file
    # system timelines, hashes, memory dumps, BitLocker volumes and Windows passwords.
    environment.systemPackages = with pkgs; [
      chntpw
      dc3dd
      dislocker
      exiftool
      ext4magic
      f3
      foremost
      fsarchiver
      guymager
      hashdeep
      hexyl
      libewf
      nwipe
      partclone
      sdparm
      sleuthkit
      ssdeep
      volatility3
      yara
    ];

    # The installer can read ZFS pools, but the image itself never boots from one.
    boot.zfs.forceImportRoot = false;

    # NetworkManager (./portable.nix) replaces the installer's wpa_supplicant.
    networking.wireless.enable = lib.mkForce false;

    # The installer profile names the image itself, so only a force wins.
    image.baseName = lib.mkForce "rescue";
    isoImage.makeEfiBootable = true;
    isoImage.makeUsbBootable = true;
  };
}
