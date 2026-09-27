{ ... }:
let
  c = import ../../lib/colors.nix;
  rgb = c.hexToRgb;

  qtColorScheme = ''
    [ColorScheme]
    active_colors=${c.md3.on_surface}, ${c.md3.background}, ${c.md3.surface_container_high}, ${c.md3.outline}, ${c.md3.outline_variant}, ${c.md3.outline_variant}, ${c.md3.on_surface}, ${c.md3.on_primary}, ${c.md3.on_surface}, ${c.md3.background}, ${c.md3.background}, ${c.md3.shadow}, ${c.md3.primary}, ${c.md3.on_primary}, ${c.md3.secondary}, ${c.md3.secondary}, ${c.md3.surface_container_low}, ${c.md3.background}, ${c.md3.background}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}
    disabled_colors=${c.md3.on_surface_variant}, ${c.md3.outline_variant}, ${c.md3.surface_container_high}, ${c.md3.outline}, ${c.md3.outline_variant}, ${c.md3.outline_variant}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}, ${c.md3.outline_variant}, ${c.md3.outline_variant}, ${c.md3.shadow}, ${c.md3.outline_variant}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}, ${c.md3.outline_variant}, ${c.md3.outline_variant}, ${c.md3.outline_variant}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}
    inactive_colors=${c.md3.on_surface_variant}, ${c.md3.background}, ${c.md3.surface_container_high}, ${c.md3.outline}, ${c.md3.outline_variant}, ${c.md3.outline_variant}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}, ${c.md3.background}, ${c.md3.background}, ${c.md3.shadow}, ${c.md3.secondary}, ${c.md3.on_secondary}, ${c.md3.secondary}, ${c.md3.secondary}, ${c.md3.surface_container_low}, ${c.md3.background}, ${c.md3.background}, ${c.md3.on_surface_variant}, ${c.md3.on_surface_variant}

    [ColorEffects:Disabled]
    Color=${rgb c.md3.on_surface_variant}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${rgb c.md3.outline}
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=${rgb c.md3.surface_container_high}
    BackgroundNormal=${rgb c.md3.background}
    DecorationFocus=${rgb c.md3.primary}
    DecorationHover=${rgb c.md3.primary}
    ForegroundActive=${rgb c.md3.primary}
    ForegroundInactive=${rgb c.md3.on_surface_variant}
    ForegroundLink=${rgb c.md3.tertiary}
    ForegroundNegative=${rgb c.md3.error}
    ForegroundNeutral=${rgb c.md3.secondary}
    ForegroundNormal=${rgb c.md3.on_surface}
    ForegroundPositive=${rgb c.md3.tertiary}
    ForegroundVisited=${rgb c.md3.secondary}

    [Colors:Complementary]
    BackgroundAlternate=${rgb c.md3.surface_container_high}
    BackgroundNormal=${rgb c.md3.background}
    DecorationFocus=${rgb c.md3.primary}
    DecorationHover=${rgb c.md3.primary}
    ForegroundActive=${rgb c.md3.primary}
    ForegroundInactive=${rgb c.md3.on_surface_variant}
    ForegroundLink=${rgb c.md3.tertiary}
    ForegroundNegative=${rgb c.md3.error}
    ForegroundNeutral=${rgb c.md3.secondary}
    ForegroundNormal=${rgb c.md3.on_surface}
    ForegroundPositive=${rgb c.md3.tertiary}
    ForegroundVisited=${rgb c.md3.secondary}

    [Colors:Header]
    BackgroundAlternate=${rgb c.md3.background}
    BackgroundNormal=${rgb c.md3.background}
    DecorationFocus=${rgb c.md3.primary}
    DecorationHover=${rgb c.md3.primary}
    ForegroundActive=${rgb c.md3.primary}
    ForegroundInactive=${rgb c.md3.on_surface_variant}
    ForegroundLink=${rgb c.md3.tertiary}
    ForegroundNegative=${rgb c.md3.error}
    ForegroundNeutral=${rgb c.md3.secondary}
    ForegroundNormal=${rgb c.md3.on_surface}
    ForegroundPositive=${rgb c.md3.tertiary}
    ForegroundVisited=${rgb c.md3.secondary}

    [Colors:Header][Inactive]
    BackgroundAlternate=${rgb c.md3.background}
    BackgroundNormal=${rgb c.md3.background}
    DecorationFocus=${rgb c.md3.primary}
    DecorationHover=${rgb c.md3.primary}
    ForegroundActive=${rgb c.md3.primary}
    ForegroundInactive=${rgb c.md3.on_surface_variant}
    ForegroundLink=${rgb c.md3.tertiary}
    ForegroundNegative=${rgb c.md3.error}
    ForegroundNeutral=${rgb c.md3.secondary}
    ForegroundNormal=${rgb c.md3.on_surface}
    ForegroundPositive=${rgb c.md3.tertiary}
    ForegroundVisited=${rgb c.md3.secondary}

    [Colors:Selection]
    BackgroundAlternate=${rgb c.md3.primary_container}
    BackgroundNormal=${rgb c.md3.primary}
    DecorationFocus=${rgb c.md3.primary}
    DecorationHover=${rgb c.md3.primary}
    ForegroundActive=${rgb c.md3.on_primary}
    ForegroundInactive=${rgb c.md3.on_surface_variant}
    ForegroundLink=${rgb c.md3.tertiary}
    ForegroundNegative=${rgb c.md3.error}
    ForegroundNeutral=${rgb c.md3.secondary}
    ForegroundNormal=${rgb c.md3.on_primary}
    ForegroundPositive=${rgb c.md3.tertiary}
    ForegroundVisited=${rgb c.md3.secondary}

    [Colors:Tooltip]
    BackgroundAlternate=${rgb c.md3.background}
    BackgroundNormal=${rgb c.md3.background}
    DecorationFocus=${rgb c.md3.primary}
    DecorationHover=${rgb c.md3.primary}
    ForegroundActive=${rgb c.md3.primary}
    ForegroundInactive=${rgb c.md3.on_surface_variant}
    ForegroundLink=${rgb c.md3.tertiary}
    ForegroundNegative=${rgb c.md3.error}
    ForegroundNeutral=${rgb c.md3.secondary}
    ForegroundNormal=${rgb c.md3.on_surface}
    ForegroundPositive=${rgb c.md3.tertiary}
    ForegroundVisited=${rgb c.md3.secondary}

    [Colors:View]
    BackgroundAlternate=${rgb c.md3.surface_container_low}
    BackgroundNormal=${rgb c.md3.background}
    DecorationFocus=${rgb c.md3.primary}
    DecorationHover=${rgb c.md3.primary}
    ForegroundActive=${rgb c.md3.primary}
    ForegroundInactive=${rgb c.md3.on_surface_variant}
    ForegroundLink=${rgb c.md3.tertiary}
    ForegroundNegative=${rgb c.md3.error}
    ForegroundNeutral=${rgb c.md3.secondary}
    ForegroundNormal=${rgb c.md3.on_surface}
    ForegroundPositive=${rgb c.md3.tertiary}
    ForegroundVisited=${rgb c.md3.secondary}

    [Colors:Window]
    BackgroundAlternate=${rgb c.md3.background}
    BackgroundNormal=${rgb c.md3.background}
    DecorationFocus=${rgb c.md3.primary}
    DecorationHover=${rgb c.md3.primary}
    ForegroundActive=${rgb c.md3.primary}
    ForegroundInactive=${rgb c.md3.on_surface_variant}
    ForegroundLink=${rgb c.md3.tertiary}
    ForegroundNegative=${rgb c.md3.error}
    ForegroundNeutral=${rgb c.md3.secondary}
    ForegroundNormal=${rgb c.md3.on_surface}
    ForegroundPositive=${rgb c.md3.tertiary}
    ForegroundVisited=${rgb c.md3.secondary}

    [WM]
    activeBackground=${rgb c.md3.background}
    activeBlend=${rgb c.md3.on_surface}
    activeForeground=${rgb c.md3.on_surface}
    inactiveBackground=${rgb c.md3.background}
    inactiveBlend=${rgb c.md3.on_surface_variant}
    inactiveForeground=${rgb c.md3.on_surface_variant}
  '';

in
{
  # Qt theme: adwaita-qt plugin so Qt apps (Nextcloud, KDE Connect, etc.) go dark
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Qt color schemes
  xdg.configFile."qt5ct/colors/matugen.conf".text = qtColorScheme;
  xdg.configFile."qt6ct/colors/matugen.conf".text = qtColorScheme;

  # KDE app colors (kdeconnect, etc.), read from the [Colors:*] sections of the same palette
  xdg.configFile."kdeglobals".text = qtColorScheme;
}
