{ ... }:
{
  programs.dank-material-shell.settings = {
    acMonitorTimeout = 600;
    acLockTimeout = 595;
    acSuspendTimeout = 900;
    acSuspendBehavior = 2;
    batteryMonitorTimeout = 300;
    batteryLockTimeout = 295;
    batterySuspendTimeout = 600;
    batterySuspendBehavior = 2;
    batteryCriticalThreshold = 15;
    batteryLowThreshold = 25;
    batteryNotifyLow = true;
  };
}
