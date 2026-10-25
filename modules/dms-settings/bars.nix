{ ... }:
{
  programs.dank-material-shell.settings = {
    barConfigs = [
      {
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
        islandCompactThickness = 38;
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
      }
    ];
  };
}
