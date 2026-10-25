# Idle defaults meant to suit most machines: on AC the screen locks and turns off after 15
# minutes and the machine stays awake; on battery that happens after 5 minutes and it
# suspends after 15. The lock comes 5 seconds before the screen goes off.
{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    acMonitorTimeout = 900;
    acLockTimeout = 895;
    batteryMonitorTimeout = 300;
    batteryLockTimeout = 295;
    batterySuspendTimeout = 900;
    batteryNotifyLow = true;
  };
}
