# The DMS layout from the laptop profile: dock, control center, dash, bar (island mode,
# left edge) and the AC/battery idle timeouts. Needs the dank-material-shell home module
# from the dms flake, which this module does not import.
{ ... }:
{
  programs.dank-material-shell.settings = {
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
        order = [ ];
        widgets = [
          {
            enabled = true;
            id = "dock_launcher";
            widgetId = "dockLauncher";
          }
          {
            appsDockColorizeActive = false;
            appsDockEnlargeOnHover = false;
            appsDockIconSizePercentage = 100;
            enabled = true;
            id = "dock_apps";
            runningAppsCurrentWorkspace = false;
            widgetId = "appsDock";
          }
          {
            enabled = false;
            id = "dock_trash";
            widgetId = "dockTrash";
          }
        ];
      }
    ];

    controlCenterWidgets = [
      {
        enabled = true;
        h = 1;
        id = "user";
        w = 5;
      }
      {
        enabled = true;
        h = 1;
        id = "settings";
        small = true;
        w = 1;
      }
      {
        enabled = true;
        h = 1;
        id = "lock";
        small = true;
        w = 1;
      }
      {
        enabled = true;
        h = 1;
        id = "power";
        small = true;
        w = 1;
      }
      {
        enabled = true;
        h = 1;
        id = "volumeSlider";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "brightnessSlider";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "wifi";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "bluetooth";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "audioOutput";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "audioInput";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "plugin_dankKDEConnect";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "idleInhibitor";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "colorPicker";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "doNotDisturb";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "battery";
        w = 4;
      }
      {
        enabled = true;
        h = 1;
        id = "nightMode";
        w = 4;
      }
      {
        enabled = true;
        footer = true;
        h = 1;
        id = "runningApps";
        w = 4;
      }
      {
        enabled = true;
        footer = true;
        footerEnd = true;
        h = 1;
        id = "edit";
        small = true;
        w = 1;
      }
    ];

    dashCards = [
      {
        col = 0;
        h = 1;
        id = "clock";
        row = 0;
        w = 2;
      }
      {
        col = 2;
        h = 1;
        id = "weather";
        row = 0;
        w = 1;
      }
      {
        col = 3;
        h = 5;
        id = "notifications";
        row = 0;
        w = 3;
      }
      {
        col = 0;
        h = 3;
        id = "calendar";
        row = 1;
        w = 3;
      }
      {
        col = 0;
        h = 1;
        id = "sysmon";
        row = 4;
        w = 3;
      }
    ];

    dashOptions = {
      media = {
        artStyle = "circle";
        playerStyle = "material";
      };
      wallpaper = {
        panelRows = 5;
      };
      weather = {
        city = true;
        widgets = [
          {
            col = 0;
            graphics = true;
            h = 2;
            id = "conditions";
            row = 0;
            w = 2;
          }
          {
            col = 2;
            graphics = true;
            h = 2;
            id = "daily";
            row = 0;
            w = 2;
          }
          {
            col = 0;
            graphics = true;
            h = 2;
            id = "hourly";
            row = 2;
            w = 4;
          }
          {
            col = 1;
            graphics = true;
            h = 2;
            id = "humidity";
            row = 4;
            w = 1;
          }
          {
            col = 0;
            graphics = true;
            h = 2;
            id = "wind";
            row = 4;
            w = 1;
          }
          {
            col = 2;
            graphics = true;
            h = 2;
            id = "precipitation";
            row = 4;
            w = 1;
          }
          {
            col = 3;
            graphics = true;
            h = 2;
            id = "pressure";
            row = 4;
            w = 1;
          }
        ];
        panelColumns = 7;
      };
    };

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

    barConfigs = [
      {
        autoHide = false;
        autoHideDelay = 250;
        barInsetPadding = 10;
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
        islandNotificationExpand = true;
        islandNotificationPopups = false;
        islandOuterGap = 4;
        islandPalette = "default";
        islandPlacement = "edge";
        islandReserveThickness = 24;
        islandRouteLauncher = "island";
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
            id = "systemTray";
          }
          {
            enabled = false;
            id = "memUsage";
          }
          {
            enabled = true;
            id = "cpuTemp";
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
        scrollEnabled = true;
        scrollXBehavior = "none";
        scrollYBehavior = "column";
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
