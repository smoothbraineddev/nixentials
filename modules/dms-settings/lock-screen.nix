{ lib, ... }:
let
  dms = import ../../lib/dms.nix;
in
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    lockScreenShowPowerActions = false;
    lockBeforeSuspend = true;
    lockScreenWidgetInstances = dms.lockScreenWidgets;
    greeterWidgetInstances = dms.greeterWidgets dms.lockScreenWidgets;
  };
}
