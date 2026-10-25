{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    osdAlwaysShowValue = true;
    osdMediaPlaybackEnabled = true;
    osdPowerProfileEnabled = true;
  };
}
