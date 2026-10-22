{ lib, ... }:
{
  programs.niri.settings = {
    # === Layout ===
    layout = {
      gaps = lib.mkDefault 5;
      struts = lib.mkDefault {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };
      background-color = "transparent";
      center-focused-column = "never";

      preset-column-widths = [
        { fixed = 369; }
        { fixed = 745; }
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

      focus-ring.enable = false;

      border.enable = false;

      tab-indicator = {
        gap = 3;
        width = 5;
        position = "left";
        length.total-proportion = 0.42;
        gaps-between-tabs = 5;
        corner-radius = 5;
        hide-when-single-tab = false;
        place-within-column = true;
      };

      shadow.enable = false;
    };

  };
}
