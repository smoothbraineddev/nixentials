# The DMS settings of the laptop config: the shared keys (theme, launcher, notifications, lock
# screen, cursor, niri layout) and the laptop profile (dock, control center, dash, bar in
# island mode on the left edge, AC/battery idle timeouts), plus the feature toggles and
# clipboard settings. Only values that differ from the DMS defaults. One file per section of
# the DMS settings sidebar (Common/SettingsTabs.qml in the package); sections with one or two
# keys share general.nix. Needs the dank-material-shell home module from the dms flake, which
# this module does not import.
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
