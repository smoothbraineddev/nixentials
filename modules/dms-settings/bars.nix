{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    barConfigs = [ (import ../../lib/dms.nix).bar ];
  };
}
