{ ... }:
{
  programs.niri.settings = {
    # === Cursor ===
    cursor = {
      theme = "Bibata-Modern-Classic";
      size = 12;
      hide-when-typing = true;
      hide-after-inactive-ms = 1000;
    };

    # === Input ===
    input = {
      keyboard = {
        xkb = {
          layout = "us";
          variant = "intl";
          options = "compose:rctrl-altgr";
        };
        track-layout = "global";
        numlock = true;
      };
      touchpad = {
        tap = true;
        dwt = true;
        natural-scroll = true;
      };
      mouse = {
        # accel-speed = -0.96;
        accel-speed = 0.75;
        accel-profile = "flat";
      };
    };

    gestures.hot-corners.enable = false;

  };
}
