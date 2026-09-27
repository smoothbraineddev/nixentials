{ lib, ... }:
{
  programs.niri.settings = {
    # === Layout ===
    layout = {
      gaps = lib.mkDefault 15;
      background-color = "transparent";
      center-focused-column = "never";

      preset-column-widths = [
        { fixed = 360; }
        { fixed = 741; }
        { proportion = 0.25; }
        { proportion = 0.33333; }
        { proportion = 0.4125; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 0.75; }
      ];

      preset-window-heights = [
        { fixed = 489; }
        { fixed = 678; }
        { fixed = 703; }
        { fixed = 725; }
        { fixed = 765; }
        { fixed = 805; }
        { proportion = 0.25; }
        { proportion = 0.33333; }
        { proportion = 0.4125; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 0.75; }
        { proportion = 0.85; }
      ];

      default-column-width.proportion = 0.5;

      focus-ring.width = 2.5;

      border.enable = false;

      shadow.enable = false;
    };

  };
}
