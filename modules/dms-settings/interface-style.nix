{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    radiusStrength = 38;
    barElevationEnabled = false;
    popupTransparency = 0.9;
    foregroundLayerTransparency = 0.5;
    blurEnabled = false;
    blurBorderOpacity = 0.83;
    blurBorderSeeded = true;
  };
}
