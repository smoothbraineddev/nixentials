# A complete DMS config: theme, launcher, notifications, lock screen, cursor, niri layout,
# dash, the island notch bar on the left edge of every screen, a dock with launcher, apps
# and trash, the control center, idle timeouts, the feature toggles and clipboard settings.
# Only values that differ from the DMS defaults. Every leaf is a mkDefault, so a consumer
# overrides any key with a plain value; lists such as barConfigs and dockConfigs are
# replaced whole. One file per section of the DMS settings sidebar (Common/SettingsTabs.qml
# in the package); sections with one or two keys share general.nix. Needs the
# dank-material-shell home module from the dms flake, which this module does not import.
{ ... }:
{
  imports = [
    ./bars.nix
    ./colors.nix
    ./config.nix
    ./control-center.nix
    ./dash.nix
    ./dock.nix
    ./fonts-motion.nix
    ./general.nix
    ./interface-style.nix
    ./launcher.nix
    ./lock-screen.nix
    ./notifications.nix
    ./osd.nix
    ./power-battery.nix
  ];
}
