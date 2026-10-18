{ ... }:
let
  c = import ../../../lib/colors.nix;
in
{
  programs.wezterm.extraConfig = ''
    -- Colors
    config.colors = {
      background    = '${c.md3.surface_container_lowest}',
      foreground    = '${c.md3.on_surface}',
      selection_bg  = '${c.md3.primary_container}',
      selection_fg  = '${c.md3.on_surface}',
      cursor_bg     = '${c.md3.primary}',
      cursor_fg     = '${c.md3.background}',
      cursor_border = '${c.md3.primary}',
      ansi = {
        '${c.dank16.bg}',
        '${c.dank16.red}',
        '${c.dank16.green}',
        '${c.dank16.tan}',
        '${c.dank16.amber}',
        '${c.dank16.brown}',
        '${c.dank16.gold}',
        '${c.dank16.silver}',
      },
      brights = {
        '${c.dank16.gray}',
        '${c.dank16.pink}',
        '${c.dank16.bright_green}',
        '${c.dank16.cream}',
        '${c.dank16.bright_gold}',
        '${c.dank16.warm_brown}',
        '${c.dank16.olive}',
        '${c.dank16.white}',
      },
    }
  '';
}
