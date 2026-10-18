# The system half of a graphical session: enough for niri, DMS and the home-manager
# modules in this flake to work, and nothing else.

{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
        user = "greeter";
      };
    };
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.niri.enable = true;
  # Toggling the left strut negative moves windows into the freed space. Without it, niri
  # leaves them beside the old edge until a focus change refits the view.
  nixpkgs.overlays = [
    (final: prev: {
      niri = prev.niri.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../patches/niri-view-follows-left-strut.patch ];
      });
    })
  ];
  programs.xwayland.enable = true;
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  # File-manager support: gvfs for trash and removable, network and MTP mounts, tumbler
  # for Nautilus thumbnails.
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.GTK_USE_PORTAL = "1";
}
