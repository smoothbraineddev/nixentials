{ ... }:
{
  # Sections of the DMS settings sidebar with one or two keys; the others
  # have their own file in this directory.
  programs.dank-material-shell.settings = {
    # Keep in step with settingsConfigVersion in the DMS package
    # (share/quickshell/dms/Common/SettingsData.qml). An older version makes DMS
    # migrate the read-only settings in memory on every start.
    configVersion = 42;
    clockFormat = "24h";
    powerMenuActions = [
      "reboot"
      "logout"
      "poweroff"
      "lock"
      "suspend"
      "hibernate"
      "restart"
    ];
    dmsWindowsFloatingSeeded = [ "niri" ];
    appIdSubstitutions = [ ];
    # -2 leaves gaps out of the DMS layout.kdl, so each host keeps its Nix gaps.
    niriLayoutGapsOverride = -2;
    soundPluggedIn = false;
    touchpadDragLock = true;
    avatarRing = "primary";
  };
}
