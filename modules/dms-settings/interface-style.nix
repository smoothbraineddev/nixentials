{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    radiusStrength = 50;
    popupTransparency = 0.9;
    foregroundLayerTransparency = 0;
    blurEnabled = false;
    barElevationEnabled = true;
    m3ElevationIntensity = 12;
    m3ElevationLightDirection = "autoBar";
    m3ElevationOpacity = 30;
  };
}
