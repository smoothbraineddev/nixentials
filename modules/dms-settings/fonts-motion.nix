{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    animationDuration = 420;
    fontWeight = 600;
    fontScale = 0.85;
    fontFamily = "Google Sans Flex Black";
    displayFontFamily = "Google Sans Flex";
    monoFontFamily = "JetBrainsMono Nerd Font";
    textRenderType = 1;
    textRenderQuality = 4;
    springBounce = 2;
    motionEffect = 3;
  };
}
