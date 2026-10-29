{ lib, ... }:
{
  programs.dank-material-shell.settings = lib.mapAttrsRecursive (_: lib.mkDefault) {
    dockConfigs = [
      {
        id = "dock";
        name = "Dock";
        enabled = true;
        screenPreferences = [
          "all"
        ];
        showOnLastDisplay = true;
        position = 1;
        mode = "compact";
        taskbarAlign = "center";
        widgetExpansion = "inline";
        iconSize = 36;
        spacing = 8;
        itemSpacing = 8;
        margin = 0;
        bottomGap = 0;
        transparency = 0;
        followInterfaceStyle = false;
        autoHide = false;
        smartAutoHide = true;
        useOverlayLayer = false;
        editOnRightClick = false;
        showOnFullscreen = false;
        openOnOverview = true;
        groupByApp = true;
        separatePinnedAndRunningApps = false;
        restoreSpecialWorkspaceOnClick = false;
        isolateDisplays = false;
        indicatorStyle = "circle";
        borderEnabled = false;
        borderColor = "surfaceText";
        borderOpacity = 1;
        borderThickness = 1;
        launcherEnabled = false;
        launcherLogoMode = "os";
        launcherLogoCustomPath = "";
        launcherLogoColorOverride = "";
        launcherLogoSizeOffset = 0;
        launcherLogoBrightness = 0.5;
        launcherLogoContrast = 1;
        maxVisibleApps = 0;
        maxVisibleRunningApps = 0;
        showOverflowBadge = true;
        showTrash = true;
        trashFileManager = "nautilus";
        trashCustomCommand = "";
        magnification = true;
        magnificationScale = 130;
        magnificationProfile = "parabolic";
        magnificationExpand = false;
        order = [ ];
        widgets = [
          {
            enabled = true;
            id = "dock_launcher";
            widgetId = "dockLauncher";
          }
          {
            appsDockColorizeActive = false;
            enabled = true;
            id = "dock_apps";
            runningAppsCurrentWorkspace = false;
            widgetId = "appsDock";
          }
          {
            enabled = true;
            id = "dock_trash";
            widgetId = "dockTrash";
          }
        ];
      }
    ];
  };
}
