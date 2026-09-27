{ pkgs, ... }:
let
  c = import ../../lib/colors.nix;

  papirus-yellow = pkgs.papirus-icon-theme.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.papirus-folders ];
    postInstall = (old.postInstall or "") + ''
      XDG_DATA_DIRS="$out/share" \
        papirus-folders -t Papirus-Dark -C yellow --once
    '';
  });

  gtkColors = ''
    /*
    * GTK Colors
    * Generated with Matugen
    */

    /* via thairanaru on GitHub: */

    /* Destructive colors are basically error colors */
    @define-color destructive_bg_color ${c.md3.error};
    @define-color destructive_fg_color ${c.md3.on_error};
    /* Follow material spec */
    @define-color error_bg_color ${c.md3.error};
    @define-color error_fg_color ${c.md3.on_error};
    /* Follow material spec (also I think looks nicer) */
    @define-color accent_fg_color ${c.md3.on_primary};
    @define-color accent_bg_color ${c.md3.primary};
    /* Use surface instead of background */
    @define-color window_bg_color ${c.md3.surface_container_lowest};
    @define-color window_fg_color ${c.md3.on_surface};
    /* Make it more similar to Adwaita */
    @define-color view_bg_color ${c.md3.surface_container_lowest};
    @define-color view_fg_color ${c.md3.on_surface};
    @define-color headerbar_bg_color ${c.md3.surface_container_lowest};
    @define-color headerbar_fg_color ${c.md3.on_surface};
    @define-color sidebar_bg_color ${c.md3.background};
    @define-color sidebar_fg_color ${c.md3.on_surface};
    /* There is only like one application I know that uses this, and there isn't a good way to get
    a color between surface and surface container so I think just giving this surface is a good enough fallback*/
    @define-color secondary_sidebar_bg_color ${c.md3.surface_container_lowest};
    @define-color secondary_sidebar_fg_color ${c.md3.on_surface};
    @define-color card_bg_color ${c.md3.background};
    @define-color card_fg_color ${c.md3.on_surface};
    @define-color overview_bg_color ${c.md3.background};
    @define-color overview_fg_color ${c.md3.on_surface};
    @define-color popover_bg_color ${c.md3.background};
    @define-color popover_fg_color ${c.md3.on_surface};
    @define-color dialog_bg_color ${c.md3.surface_container_lowest};
    @define-color dialog_fg_color ${c.md3.on_surface};

    /* Backdrop/unfocused states, so a window doesn't flash white when it loses focus */
    @define-color headerbar_backdrop_color @window_bg_color;
    @define-color sidebar_backdrop_color @sidebar_bg_color;
    @define-color theme_unfocused_fg_color @window_fg_color;
    @define-color theme_unfocused_text_color @view_fg_color;
    @define-color theme_unfocused_bg_color @window_bg_color;
    @define-color theme_unfocused_base_color @window_bg_color;
    @define-color theme_unfocused_selected_bg_color @accent_bg_color;
    @define-color theme_unfocused_selected_fg_color @accent_fg_color;
  '';

in
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
    };
  };

  # GTK 3/4 themes
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = papirus-yellow;
    };
    gtk3.extraCss = gtkColors;
    gtk4.extraCss = gtkColors;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 12;
    x11.enable = true;
    gtk.enable = true;
  };
}
