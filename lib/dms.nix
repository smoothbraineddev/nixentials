# DMS config shipped as data. The dms-settings module sets barConfigs to [ bar ] and
# dockConfigs to [ dock ], and a consumer replaces each list whole, so this is what a
# consumer builds its own bars and docks from with `bar // { ... }` and `dock // { ... }`.
{
  bar = {
    autoHide = false;
    autoHideDelay = 250;
    barInsetPadding = 20;
    borderColor = "surfaceText";
    borderEnabled = false;
    borderOpacity = 1;
    borderThickness = 1;
    bottomGap = 0;
    clickThrough = false;
    dot = false;
    enabled = true;
    followInterfaceStyle = true;
    fontScale = 1;
    gothCornerRadiusOverride = false;
    gothCornerRadiusValue = 12;
    gothCornersEnabled = false;
    hoverPopoutDelay = 150;
    hoverPopouts = true;
    id = "default";
    innerPadding = 4;
    island = true;
    islandAlongOffset = 0;
    islandCompactThickness = 36;
    # The pill face is 2px wider than islandCompactThickness. DMS reserves 40px unless
    # told otherwise, which leaves windows 2px farther from the notch than the gaps.
    islandReserveThickness = 25;
    islandFloating = false;
    islandHomeLayout = [
      {
        enabled = true;
        id = "media";
      }
      {
        enabled = true;
        id = "clock";
      }
      {
        enabled = true;
        id = "weather";
      }
      {
        enabled = false;
        id = "status";
      }
      {
        enabled = false;
        id = "volume";
      }
      {
        enabled = false;
        id = "brightness";
      }
      {
        enabled = false;
        id = "notifications";
      }
    ];
    islandHoverCloseDelay = 150;
    islandHoverOpenDelay = 150;
    islandInteractionMode = "hybrid";
    islandMediaClockVisible = true;
    islandNotch = true;
    islandNotificationExpand = true;
    islandNotificationPopups = false;
    islandOuterGap = 3;
    islandPalette = "default";
    islandPlacement = "edge";
    islandRouteLauncher = "island";
    islandRoutePowerMenu = "island";
    islandSatelliteBackground = false;
    islandSatelliteGap = 0;
    islandSatelliteGothCorners = false;
    islandSatellitePosition = "edges";
    islandSystemOsd = true;
    leftWidgets = [
      {
        enabled = true;
        id = "workspaceSwitcher";
      }
    ];
    maximizeDetection = true;
    maximizeWidgetIcons = false;
    maximizeWidgetText = false;
    name = "Main Bar";
    noBackground = true;
    openOnOverview = true;
    popupGapsAuto = true;
    popupGapsManual = 4;
    position = 2;
    rightWidgets = [
      {
        enabled = true;
        id = "memUsage";
      }
      {
        enabled = true;
        id = "cpuTemp";
      }
      {
        enabled = true;
        id = "cpuUsage";
      }
      {
        enabled = true;
        id = "systemTray";
      }
      {
        enabled = true;
        id = "controlCenterButton";
        showMicPercent = true;
      }
      {
        enabled = true;
        id = "battery";
      }
    ];
    screenPreferences = [
      "all"
    ];
    scrollEnabled = false;
    scrollXBehavior = "none";
    scrollYBehavior = "focusWindow";
    shadowColorMode = "text";
    shadowCustomColor = "#000000";
    shadowIntensity = 0;
    shadowOpacity = 60;
    showOnLastDisplay = true;
    showOnWindowsOpen = true;
    spacing = 4;
    squareCorners = false;
    transparency = 1;
    visible = true;
    widgetFollowInterfaceStyle = true;
    widgetOutlineColor = "primary";
    widgetOutlineEnabled = false;
    widgetOutlineOpacity = 1;
    widgetOutlineThickness = 1;
    widgetPadding = 5;
    widgetTransparency = 1;
    islandRouteNotificationCenter = "island";
    islandRouteControlCenter = "bar";
    islandRouteClipboard = "island";
    islandHomeCompactTight = false;
    surfaceColor = "default";
    islandHighContrast = false;
    surfaceCustomColor = "#25003b";
    widgetStyle = "pills";
  };

  dock = {
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
    iconSize = 32;
    spacing = 8;
    itemSpacing = 8;
    margin = 8;
    bottomGap = 0;
    transparency = 0;
    followInterfaceStyle = false;
    autoHide = false;
    smartAutoHide = true;
    useOverlayLayer = true;
    editOnRightClick = false;
    showOnFullscreen = true;
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
    magnificationScale = 125;
    magnificationProfile = "parabolic";
    magnificationExpand = true;
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
  };
}
