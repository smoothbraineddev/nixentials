{ pkgs, ... }:
{
  programs.niri.settings = {
    # === Environment ===
    environment = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland";
      TERMINAL = "wezterm";
      XDG_CURRENT_DESKTOP = "niri";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "10";
    };

    # === Startup ===
    spawn-at-startup = [
      {
        argv = [
          "systemctl"
          "--user"
          "import-environment"
          "NIRI_SOCKET"
          "WAYLAND_DISPLAY"
          "DISPLAY"
        ];
      }
      {
        argv = [
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ];
      }
      { sh = "wl-paste --watch cliphist store &"; }
      { sh = "wl-clip-persist --clipboard regular &"; }
    ];

  };
}
