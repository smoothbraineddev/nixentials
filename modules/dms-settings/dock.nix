{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    dockConfigs = [ (import ../../lib/dms.nix).dock ];
  };
}
