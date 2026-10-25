# A thin install ISO: nixpkgs' minimal installer with flakes, NetworkManager and the tools to
# partition, encrypt and install, disko-install included. No host closure: an install fetches
# its store paths from substituters. The consumer adds its keys, caches and flake source.
# Build it with config.system.build.isoImage.
{
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # NetworkManager on iwd, in place of the installer's wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.enable = true;
  networking.wireless.enable = lib.mkForce false;

  # Logins only over SSH keys, as the installer's `nixos` user with passwordless sudo.
  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = lib.mkForce "no";

  environment.systemPackages = with pkgs; [
    btrfs-progs
    cryptsetup
    disko
    dosfstools
    git
    gptfdisk
    helix
    nixos-install-tools
    parted
    tmux
  ];

  # The installer can read ZFS pools, but the image itself never boots from one.
  boot.zfs.forceImportRoot = false;

  # The installer profile names the image itself, so only a force wins.
  image.baseName = lib.mkForce "installer";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}
