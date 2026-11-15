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
    # Text on the editor background, without beans' gray bar: the mode in color, the rest in the
    # comment gray, and the statusline of unfocused splits in the line number gray.
    "ui.statusline" = {
      fg = "light_gray";
      bg = "background";
    };
    "ui.statusline.inactive" = {
      fg = "dark_gray";
      bg = "background";
    };
    "ui.statusline.normal" = {
      fg = "mid_blue";
      bg = "background";
    };
    "ui.statusline.insert" = {
      fg = "light_purple";
      bg = "background";
    };
    # beans' own select color is near-white
    "ui.statusline.select" = {
      fg = "yellow";
      bg = "background";
    };
    # The split separator in the editor background: the line numbers divide the splits.
    "ui.window" = {
      fg = "background";
      bg = "background";
    };
  };
}
