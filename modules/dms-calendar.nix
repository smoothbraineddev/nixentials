# Points the DMS dash calendar at DankCalendar (dcal) and runs dcal as a user service. dcal
# syncs Google, Microsoft, CalDAV, iCloud and iCal accounts. Accounts are added by hand with
# `dcal account add`, so no credentials land in the store. Needs the dank-material-shell home
# module.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # `dcal run` starts its window through Quickshell's `qs`, which the user manager's PATH
  # lacks. Without it the unit crash-loops on `exec: "qs": executable file not found`.
  dcalSession = pkgs.writeShellScript "dcal-session" ''
    PATH=${lib.makeBinPath [ config.programs.dank-material-shell.quickshell.package ]}:$PATH
    exec ${lib.getExe' pkgs.dankcalendar "dcal"} run --session --hidden
  '';
in
{
  home.packages = [ pkgs.dankcalendar ];

  # Mirrors the dcal.service the package ships, with ExecStart swapped for the wrapper.
  systemd.user.services.dcal = {
    Unit = {
      Description = "Dank Calendar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${dcalSession}";
      Restart = "on-failure";
      RestartSec = 2;
      Slice = "app.slice";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # "auto" falls back to khal while dcal is down; only dcal can create events.
  programs.dank-material-shell.settings.calendarBackend = "dankcal";
}
