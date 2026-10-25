{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    notificationOverlayEnabled = true;
    notificationPopupPosition = 1;
    notificationPopupPrivacyMode = true;
    notificationCompactMode = true;
    notificationShowTimeoutBar = true;
    notificationFocusedMonitor = true;
  };
}
