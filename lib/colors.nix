# Single source of truth for the frozen Matugen colorway.
# Recursive attrset. Not a module, never imported into `imports`.
#
# Modules in this flake import it by relative path, so they stay self-contained and a
# consumer can import one without extra wiring. Consumers theming their own modules
# against it take it as a module argument instead:
#
#   _module.args.colors = inputs.nixentials.lib.colors;   # set once
#   { colors, ... }: let c = colors; in ...             # in each module
#
let
  hexToInt = hex: (fromTOML "v=0x${hex}").v;
in
rec {
  # ── Canonical color values (all hex lives here) ───────────────────────────
  smoothbrained = {
    # Neutrals: the surface stack, darkest to lightest
    black = "#000000"; # pure black
    abyss = "#0e0e0e"; # near-black (darkest surface)
    base = "#131313"; # near-black (main background)
    shade = "#1b1b1b"; # near-black
    dim = "#1f1f1f"; # near-black
    muted = "#2a2a2a"; # dark gray
    charcoal = "#303030"; # dark gray
    graphite = "#393939"; # dark gray
    slate = "#474747"; # dark gray
    gray = "#919191";
    ash = "#c6c6c6"; # light gray
    silver = "#e2e2e2";
    white = "#ffffff";
    # Terminal-specific grays (dank16 slots)
    cool_gray = "#5c6370"; # medium gray
    warm_gray = "#abb2bf"; # blue-tinted light gray

    # Golds / primary palette
    gold = "#f2bf48"; # primary gold
    bright_gold = "#f5cf89";
    pale_gold = "#ffdf9e"; # pale gold / cream
    source = "#f6bb19"; # source amber
    amber = "#b38723"; # dark amber
    umber = "#795900"; # dark umber
    bronze = "#5b4300";

    # Warm tones: creams, tans, browns
    cream = "#f5e0bb"; # warm cream
    warm_cream = "#e8c497"; # pale tan
    tan = "#d8c4a0";
    warm_tan = "#dbb07b";
    dark_brown = "#3f2e00"; # very dark brown
    dark_sepia = "#3b2f15";
    espresso = "#261a00";
    deep_espresso = "#241a04";
    deep_umber = "#52452a";
    brown = "#b5964f"; # warm brown
    rust = "#a26f39";
    olive = "#877836";

    # Reds / pinks / errors
    red = "#e14879"; # pinkish red
    pink = "#e05f8c"; # bright pink
    salmon = "#ffb4ab";
    blush = "#ffdad6";
    crimson = "#93000a";
    maroon = "#690005";

    # Greens
    green = "#94d66e"; # lime green
    lime = "#a7e086"; # bright lime
    sage = "#b0cfa9";
    mint = "#ccebc4";
    forest = "#334d31";
    dark_forest = "#1d361c";
    deep_forest = "#072109";
  };

  # Syntax highlighting palette derived from jellybeans, used by the Zed theme
  beans = {
    yellow = "#fad07a";
    light_yellow = "#ebebd8";
    green = "#ccff00";
    dark_green = "#cee318";
    light_blue = "#48c6ff";
    mid_blue = "#8197bf";
    dark_blue = "#0ac1cd";
    purple = "#833c9f";
    light_purple = "#be67e1";
    dark_orange = "#ff005b";
    light_gray = "#6d6d6d";
    red_accent = "#f44747";
    diff_plus = "#5a9f81";
  };

  # ── Gruvbox, retro groove palette (morhetz/gruvbox) ──────────────────────
  gruvbox = {
    # Backgrounds, dark to light
    bg_hard = "#1d2021";
    bg = "#282828";
    bg_soft = "#32302f";
    bg1 = "#3c3836";
    bg2 = "#504945";
    bg3 = "#665c54";
    bg4 = "#7c6f64";

    # Foregrounds, light to dark
    fg0 = "#fbf1c7";
    fg1 = "#ebdbb2";
    fg2 = "#d5c4a1";
    fg3 = "#bdae93";
    fg4 = "#a89984";

    # Gray
    gray = "#928374";

    # Neutral accents
    red = "#cc241d";
    green = "#98971a";
    yellow = "#d79921";
    blue = "#458588";
    purple = "#b16286";
    aqua = "#689d6a";
    orange = "#d65d0e";

    # Bright accents
    bright_red = "#fb4934";
    bright_green = "#b8bb26";
    bright_yellow = "#fabd2f";
    bright_blue = "#83a598";
    bright_purple = "#d3869b";
    bright_aqua = "#8ec07c";
    bright_orange = "#fe8019";

    # Faded accents
    faded_red = "#9d0006";
    faded_green = "#79740e";
    faded_yellow = "#b57614";
    faded_blue = "#076678";
    faded_purple = "#8f3f71";
    faded_aqua = "#427b58";
    faded_orange = "#af3a03";
  };

  # ── Terminal ANSI 16-color palette ────────────────────────────────────────
  dank16 = with smoothbrained; {
    bg = base; # near-black (ANSI 0, black slot)
    red = red; # pinkish red (ANSI 1)
    green = green; # lime green (ANSI 2)
    tan = warm_tan; # warm tan (ANSI 3, yellow slot)
    amber = amber; # dark amber (ANSI 4, blue slot)
    brown = brown; # warm brown (ANSI 5, magenta slot)
    gold = gold; # gold (ANSI 6, cyan slot)
    silver = warm_gray; # blue-tinted (ANSI 7, white slot)
    gray = cool_gray; # medium gray (ANSI 8, bright black)
    pink = pink; # bright pink (ANSI 9, bright red)
    bright_green = lime; # bright lime (ANSI 10, bright green)
    cream = warm_cream; # pale tan (ANSI 11, bright yellow)
    bright_gold = bright_gold; # bright gold (ANSI 12, bright blue)
    warm_brown = rust; # rust (ANSI 13, bright magenta)
    olive = olive; # olive (ANSI 14, bright cyan)
    white = white; # white (ANSI 15)
  };

  # ── MD3 semantic roles, referencing smoothbrained values ─────────────────
  md3 = with smoothbrained; {
    background = base;
    error = salmon;
    error_container = crimson;
    inverse_on_surface = charcoal;
    inverse_primary = umber;
    inverse_surface = silver;
    on_background = silver;
    on_error = maroon;
    on_error_container = blush;
    on_primary = dark_brown;
    on_primary_container = pale_gold;
    on_primary_fixed = espresso;
    on_primary_fixed_variant = bronze;
    on_secondary = dark_sepia;
    on_secondary_container = cream;
    on_secondary_fixed = deep_espresso;
    on_secondary_fixed_variant = deep_umber;
    on_surface = silver;
    on_surface_variant = ash;
    on_tertiary = dark_forest;
    on_tertiary_container = mint;
    on_tertiary_fixed = deep_forest;
    on_tertiary_fixed_variant = forest;
    outline = gray;
    outline_variant = slate;
    primary = gold;
    primary_container = bronze;
    primary_fixed = pale_gold;
    primary_fixed_dim = gold;
    scrim = black;
    secondary = tan;
    secondary_container = deep_umber;
    secondary_fixed = cream;
    secondary_fixed_dim = tan;
    shadow = black;
    source_color = source;
    surface = base;
    surface_bright = graphite;
    surface_container = base;
    surface_container_high = dim;
    surface_container_highest = muted;
    surface_container_low = shade;
    surface_container_lowest = abyss;
    surface_dim = base;
    surface_tint = gold;
    surface_variant = slate;
    tertiary = sage;
    tertiary_container = forest;
    tertiary_fixed = mint;
    tertiary_fixed_dim = sage;
  };

  # Strips the leading '#' from a hex color, for spicetify which uses bare hex
  stripHash = hex: builtins.substring 1 6 hex;

  # Converts "#RRGGBB" to "R,G,B" decimal string for Qt color schemes
  hexToRgb =
    hex:
    let
      h = builtins.substring 1 6 hex;
      r = hexToInt (builtins.substring 0 2 h);
      g = hexToInt (builtins.substring 2 2 h);
      b = hexToInt (builtins.substring 4 2 h);
    in
    "${toString r},${toString g},${toString b}";
}
