{ pkgs, ... }:
{
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;

  programs.niri.settings = {
    # === Misc Settings ===
    prefer-no-csd = true;
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
    hotkey-overlay.skip-at-startup = true;
    config-notification.disable-failed = true;
    overview.workspace-shadow.enable = false;
    debug.honor-xdg-activation-with-invalid-serial = true;

    layer-rules = [
      {
        matches = [ { namespace = "^quickshell$"; } ];
        place-within-backdrop = true;
      }
      # DMS desktop widgets, so they stay with the wallpaper instead of moving with each
      # workspace. Only click-through ones, which dms-patches puts on the background layer.
      {
        matches = [ { namespace = "^dms:desktop-widget:"; } ];
        place-within-backdrop = true;
      }
    ];

  };
}
