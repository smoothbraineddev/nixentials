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
    ];

  };
}
