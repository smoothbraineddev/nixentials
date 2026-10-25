# Settings for a system that boots on any x86_64 machine instead of one known one: an
# install on a USB stick, or a live image. Hardware detection would pin it to the machine it
# ran on, so the drivers it may need are listed by hand.
{ lib, pkgs, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.initrd.availableKernelModules = [
    # The stick itself. Without these, root never appears.
    "usb_storage"
    "uas"
    # USB controllers
    "xhci_pci"
    "ehci_pci"
    # Internal disks, so they are visible once booted
    "nvme"
    "ahci"
    "sd_mod"
    # The keyboard, so a LUKS prompt takes input on machines without PS/2 emulation
    "usbhid"
    "hid_generic"
  ];
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = true;

  # A boot entry in the NVRAM of every machine the system is rebuilt on helps no one. The
  # bootloader goes to the removable-media path (EFI/BOOT/BOOTX64.EFI) instead.
  boot.loader.efi.canTouchEfiVariables = false;

  # No swap partition to wear out or to resume from after the stick moved machines.
  zramSwap.enable = lib.mkDefault true;

  networking.networkmanager.enable = lib.mkDefault true;

  # Inspecting, repairing and recovering disks and machines
  environment.systemPackages = with pkgs; [
    btrfs-progs
    cryptsetup
    ddrescue
    dmidecode
    dosfstools
    e2fsprogs
    efibootmgr
    exfatprogs
    gparted
    gptfdisk
    hdparm
    lshw
    memtester
    ntfs3g
    nvme-cli
    parted
    pciutils
    rsync
    smartmontools
    testdisk
    usbutils
  ];
}
