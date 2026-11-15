{ ... }:
let
  c = import ../../lib/colors.nix;
in
{
  programs.helix.themes.beans-dark = {
    inherits = "beans";
    palette.background = c.md3.surface_container_lowest;
    # beans draws the indent guides in its "dark" gray (#898989), brighter than the comments.
    # dark_gray is the line number color.
    "ui.virtual.indent-guide" = "dark_gray";
    # The split separator in the editor background: the line numbers divide the splits.
    "ui.window" = {
      fg = "background";
      bg = "background";
    };
  };
}
