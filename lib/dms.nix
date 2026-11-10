# DMS config shipped as data. The dms-settings module sets barConfigs to [ bar ],
# dockConfigs to [ dock ] and lockScreenWidgetInstances to lockScreenWidgets, and a
# consumer replaces each list whole, so this is what a consumer builds its own bars,
# docks and lock screen from, with `bar // { ... }`, `dock // { ... }` and `map`.
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
    islandCompactThickness = 32;
    islandDashTabs = false;
    islandReserveThickness = 28;
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
    islandMediaAutoSwitch = false;
    islandMediaClockVisible = true;
    islandMediaLyrics = true;
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
    position = 3;
    rightWidgets = [
      {
        enabled = true;
        id = "systemTray";
      }
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
    islandRouteDash = "island";
    islandRouteMedia = "island";
    islandRouteWallpaper = "island";
    islandRouteWeather = "island";
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
    middleClickAction = "close";
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
  lockScreenWidgets = [
    {
      config = {
        autoPosition = true;
        colorMode = "default";
        customColor = "#ffffff";
        displayPreferences = [
          "all"
        ];
        fontFamily = "";
        showAnalogNumbers = false;
        showAnalogSeconds = true;
        showDate = false;
        showDigitalSeconds = false;
        style = "expressive";
        syncPositionAcrossScreens = true;
        transparency = 0;
        twoTone = true;
        weight = 0;
      };
      enabled = true;
      id = "lock_clock";
      widgetType = "desktopClock";
    }
    {
      config = {
        colorMode = "default";
        customColor = "#ffffff";
        displayPreferences = [
          "all"
        ];
        format = "short";
        syncPositionAcrossScreens = true;
      };
      enabled = false;
      id = "lock_date";
      widgetType = "lockDate";
    }
    {
      config = {
        displayPreferences = [
          "all"
        ];
        passwordVisibility = "typing";
        profileVisibility = "typing";
        style = "minimal";
        syncPositionAcrossScreens = true;
      };
      enabled = true;
      id = "lock_auth";
      widgetType = "lockAuth";
    }
    {
      config = {
        displayPreferences = [
          "all"
        ];
        mode = 2;
        syncPositionAcrossScreens = true;
      };
      enabled = true;
      id = "lock_notifications";
      widgetType = "lockNotifications";
    }
    {
      config = {
        background = false;
        displayPreferences = [
          "all"
        ];
        showMediaPlayer = true;
        showWeather = true;
        syncPositionAcrossScreens = true;
      };
      enabled = true;
      id = "lock_status";
      widgetType = "lockStatus";
    }
    {
      config = {
        displayPreferences = [
          "all"
        ];
        shape = "round";
        syncPositionAcrossScreens = true;
      };
      enabled = false;
      id = "lock_power";
      widgetType = "lockPower";
    }
  ];
  # The greeter list as DMS builds it from the lock screen list while greeterFollowLockScreen
  # is on (greeterWidgetsFromLock in DCommon/Common/settings/SharedSettingsSpec.js): the lock
  # widgets the greeter can show, then the session picker.
  greeterWidgets =
    lockWidgets:
    builtins.filter (
      w:
      builtins.elem w.widgetType [
        "desktopClock"
        "lockDate"
        "lockAuth"
        "lockStatus"
        "lockPower"
      ]
    ) lockWidgets
    ++ [
      {
        config = {
          displayPreferences = [
            "all"
          ];
          syncPositionAcrossScreens = true;
        };
        enabled = true;
        id = "greeter_session";
        widgetType = "greeterSession";
      }
    ];
}
