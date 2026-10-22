{ config, ... }:
{
  programs.dank-material-shell.settings = {
    currentThemeName = "custom";
    customThemeFile = "${config.xdg.configHome}/DankMaterialShell/smoothbrained-theme.json";
    currentThemeCategory = "custom";
    matugenScheme = "scheme-rainbow";
    iconThemeDark = "Papirus-Dark";
    cursorSettings = {
      dwl = {
        cursorHideTimeout = 0;
      };
      hyprland = {
        hideOnKeyPress = false;
        hideOnTouch = false;
        inactiveTimeout = 0;
      };
      niri = {
        hideAfterInactiveMs = 1000;
        hideWhenTyping = true;
      };
      size = 12;
      theme = "Bibata-Modern-Classic";
    };
    # Matugen templates for apps not installed on these hosts. Gtk, Niri, Vesktop
    # and Wezterm are enabled by default.
    matugenTemplateHyprland = false;
    matugenTemplateMangowc = false;
    matugenTemplateQt5ct = false;
    matugenTemplateQt6ct = false;
    matugenTemplateFirefox = false;
    matugenTemplatePywalfox = false;
    matugenTemplateZenBrowser = false;
    matugenTemplateEquibop = false;
    matugenTemplateGhostty = false;
    matugenTemplateKitty = false;
    matugenTemplateFoot = false;
    matugenTemplateAlacritty = false;
    matugenTemplateDgop = false;
    matugenTemplateKcolorscheme = false;
    matugenTemplateVscode = false;
    matugenTemplateEmacs = false;
  };
}
