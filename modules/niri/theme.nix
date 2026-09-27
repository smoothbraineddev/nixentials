{ ... }:
let
  c = import ../../lib/colors.nix;
  colors = {
    primary = c.md3.primary;
    outline = c.md3.outline;
    urgent = c.md3.error;
    focusRing = c.md3.surface_container_lowest;
    shadow = "${c.md3.shadow}70";
    insertHint = "${c.md3.primary}80";
  };
in
{
  programs.niri.settings.layout = {
    focus-ring = {
      active.color = colors.focusRing;
      inactive.color = "transparent";
    };

    border = {
      active.color = colors.primary;
      inactive.color = colors.outline;
      urgent.color = colors.urgent;
    };

    tab-indicator = {
      active.color = colors.primary;
      inactive.color = colors.outline;
      urgent.color = colors.urgent;
    };

    insert-hint.display.color = colors.insertHint;
  };
}
