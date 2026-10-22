{ ... }:
{
  programs.dank-material-shell.settings = {
    niriOverviewLauncherStyle = "full";
    dankLauncherV2UnloadOnClose = true;
    launcherStyle = "island";
    builtInPluginSettings = {
      dms_clipboard_search = {
        trigger = "cb";
      };
      dms_power = {
        trigger = "pw";
      };
      dms_qr_generator = {
        trigger = "qrg";
      };
      dms_settings_search = {
        trigger = "?";
      };
    };
    rememberLastMode = true;
    rememberLastQuery = false;
    spotlightSectionViewModes = {
      apps = "list";
    };
    dankLauncherV2Size = "compact";
  };
}
