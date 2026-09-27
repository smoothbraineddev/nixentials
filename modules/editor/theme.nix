{ ... }:
let
  c = import ../../lib/colors.nix;
in
{
  programs.helix.themes.beans-dark = {
    inherits = "beans";
    palette.background = c.md3.surface_container_lowest;
  };
}
