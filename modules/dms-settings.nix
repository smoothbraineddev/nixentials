# The DMS settings of the laptop config: the shared keys (theme, launcher, notifications, lock
# screen, cursor, niri layout) and the laptop profile (dock, control center, dash, bar in
# island mode on the left edge, AC/battery idle timeouts), plus the feature toggles and
# clipboard settings. Only values that differ from the DMS defaults. Needs the
# dank-material-shell home module from the dms flake, which this module does not import.
{ config, ... }:
{
  programs.dank-material-shell = {
    # feature toggles
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = false;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    clipboardSettings = {
      maxHistory = 25;
      maxEntrySize = 5242880;
      autoClearDays = 1;
      clearAtStartup = true;
      disabled = false;
      disableHistory = false;
      disablePersist = true;
    };

    settings = {
      currentThemeName = "custom";
      customThemeFile = "${config.xdg.configHome}/DankMaterialShell/smoothbrained-theme.json";
      radiusStrength = 38;
      clockFormat = "24h";
      animationDuration = 420;
      fontWeight = 600;
      monoFontFamily = "MesloLGS NF";
      # fontFamily = "DejaVu Sans";
      textRenderType = 1;
      textRenderQuality = 4;
      lockScreenShowPowerActions = true;
      powerMenuActions = [
        "reboot"
        "logout"
        "poweroff"
        "lock"
        "suspend"
        "hibernate"
        "restart"
      ];
      currentThemeCategory = "custom";
      matugenScheme = "scheme-rainbow";
      dmsWindowsFloatingSeeded = [ "niri" ];
      springBounce = 2;
      motionEffect = 3;
      barElevationEnabled = false;
      appIdSubstitutions = [ ];
      niriOverviewLauncherStyle = "full";
      dankLauncherV2UnloadOnClose = true;
      launcherStyle = "island";
      iconThemeDark = "Papirus-Dark";
      cursorSettings = {
        dwl = {
          cursorHideTimeout = 0;
        };
        hyprland = {
          hideOnKeyPress = false;
          hideOnTouch = false;
          inactiveTimeout = 0;
        };
        niri = {
          hideAfterInactiveMs = 1000;
          hideWhenTyping = true;
        };
        size = 12;
        theme = "Bibata-Modern-Classic";
      };
      # -2 leaves gaps out of the DMS layout.kdl, so each host keeps its Nix gaps.
      niriLayoutGapsOverride = -2;
      soundPluggedIn = false;
      lockBeforeSuspend = true;
      # Matugen templates for apps not installed on these hosts. Gtk, Niri, Vesktop
      # and Wezterm are enabled by default.
      matugenTemplateHyprland = false;
      matugenTemplateMangowc = false;
      matugenTemplateQt5ct = false;
      matugenTemplateQt6ct = false;
      matugenTemplateFirefox = false;
      matugenTemplatePywalfox = false;
      matugenTemplateZenBrowser = false;
      matugenTemplateEquibop = false;
      matugenTemplateGhostty = false;
      matugenTemplateKitty = false;
      matugenTemplateFoot = false;
      matugenTemplateAlacritty = false;
      matugenTemplateDgop = false;
      matugenTemplateKcolorscheme = false;
      matugenTemplateVscode = false;
      matugenTemplateEmacs = false;
      notificationOverlayEnabled = true;
      notificationPopupPosition = 1;
      osdAlwaysShowValue = true;
      osdMediaPlaybackEnabled = true;
      osdPowerProfileEnabled = true;
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
      lockScreenWidgetInstances = [
        {
          config = {
            autoPosition = true;
            colorMode = "default";
            customColor = "#ffffff";
            displayPreferences = [
              "all"
            ];
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
          enabled = true;
          id = "lock_date";
          widgetType = "lockDate";
        }
        {
          config = {
            displayPreferences = [
              "all"
            ];
            passwordVisibility = "always";
            profileVisibility = "always";
            style = "expressive";
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
          enabled = true;
          id = "lock_power";
          widgetType = "lockPower";
        }
      ];
      greeterWidgetInstances = [
        {
          config = {
            autoPosition = true;
            colorMode = "default";
            customColor = "#ffffff";
            displayPreferences = [
              "all"
            ];
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
          enabled = true;
          id = "lock_date";
          widgetType = "lockDate";
        }
        {
          config = {
            displayPreferences = [
              "all"
            ];
            passwordVisibility = "always";
            profileVisibility = "always";
            style = "expressive";
            syncPositionAcrossScreens = true;
          };
          enabled = true;
          id = "lock_auth";
          widgetType = "lockAuth";
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
          enabled = true;
          id = "lock_power";
          widgetType = "lockPower";
        }
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
      dashTabs = [
        {
          enabled = true;
          id = "overview";
        }
        {
          enabled = true;
          id = "media";
        }
        {
          enabled = true;
          id = "wallpaper";
        }
        {
          enabled = true;
          id = "weather";
        }
        {
          enabled = true;
          id = "wellbeing";
        }
        {
          enabled = true;
          id = "notifications";
        }
      ];
      popupTransparency = 0.9;
      foregroundLayerTransparency = 0.5;
      blurBorderOpacity = 0.83;
      blurBorderSeeded = true;
      touchpadDragLock = true;
      rememberLastQuery = true;
      spotlightSectionViewModes = {
        apps = "list";
      };
      dankLauncherV2Size = "micro";
      launchPrefix = "$";
      avatarRing = "primary";
      notificationPopupPrivacyMode = true;
      notificationCompactMode = true;
      notificationShowTimeoutBar = true;
      notificationFocusedMonitor = true;
      # Keep in step with settingsConfigVersion in the DMS package
      # (share/quickshell/dms/Common/SettingsData.qml). An older version makes DMS
      # migrate the read-only settings in memory on every start.
      configVersion = 40;

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
          col = 0;
          enabled = true;
          h = 1;
          id = "user";
          row = 0;
          w = 5;
        }
        {
          col = 5;
          enabled = true;
          h = 1;
          id = "settings";
          row = 0;
          small = true;
          w = 1;
        }
        {
          col = 6;
          enabled = true;
          h = 1;
          id = "lock";
          row = 0;
          small = true;
          w = 1;
        }
        {
          col = 7;
          enabled = true;
          h = 1;
          id = "power";
          row = 0;
          small = true;
          w = 1;
        }
        {
          col = 0;
          enabled = true;
          h = 1;
          id = "volumeSlider";
          row = 1;
          w = 4;
        }
        {
          col = 4;
          enabled = true;
          h = 1;
          id = "brightnessSlider";
          row = 1;
          w = 4;
        }
        {
          col = 0;
          enabled = true;
          h = 1;
          id = "wifi";
          row = 2;
          w = 4;
        }
        {
          col = 4;
          enabled = true;
          h = 1;
          id = "bluetooth";
          row = 2;
          w = 4;
        }
        {
          col = 4;
          enabled = true;
          h = 1;
          id = "audioOutput";
          row = 3;
          w = 4;
        }
        {
          col = 4;
          enabled = true;
          h = 1;
          id = "audioInput";
          row = 4;
          w = 4;
        }
        {
          col = 0;
          enabled = true;
          h = 1;
          id = "plugin_dankKDEConnect";
          row = 4;
          w = 4;
        }
        {
          col = 0;
          enabled = true;
          h = 1;
          id = "idleInhibitor";
          row = 5;
          w = 4;
        }
        {
          col = 4;
          enabled = true;
          h = 1;
          id = "doNotDisturb";
          row = 5;
          w = 4;
        }
        {
          col = 4;
          enabled = true;
          h = 1;
          id = "nightMode";
          row = 6;
          w = 4;
        }
        {
          enabled = true;
          footer = true;
          footerFill = true;
          footerW = 7;
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
        {
          col = 0;
          enabled = true;
          h = 1;
          id = "battery";
          row = 6;
          w = 4;
        }
        {
          col = 0;
          enabled = true;
          h = 1;
          id = "builtin_vpn";
          row = 3;
          w = 4;
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
          h = 6;
          id = "notifications";
          row = 0;
          w = 3;
        }
        {
          col = 0;
          h = 4;
          id = "calendar";
          row = 1;
          w = 3;
        }
        {
          col = 6;
          h = 2;
          id = "wellbeing";
          row = 4;
          w = 2;
        }
        {
          col = 0;
          h = 1;
          id = "media";
          row = 5;
          w = 3;
        }
        {
          col = 6;
          h = 1;
          id = "network";
          row = 0;
          w = 2;
        }
        {
          col = 6;
          h = 1;
          id = "cpu";
          row = 1;
          w = 2;
        }
        {
          col = 6;
          h = 1;
          id = "memory";
          row = 2;
          w = 2;
        }
        {
          col = 6;
          h = 1;
          id = "disk";
          row = 3;
          w = 2;
        }
      ];

      dashOptions = {
        calendar = {
          weekends = true;
        };
        media = {
          artStyle = "circle";
          playerStyle = "material";
        };
        overview = {
          panelColumns = 8;
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
          barInsetPadding = 8;
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
          islandReserveThickness = 0;
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
        {
          autoHide = false;
          autoHideDelay = 250;
          barInsetPadding = 8;
          borderColor = "surfaceText";
          borderEnabled = false;
          borderOpacity = 1;
          borderThickness = 1;
          bottomGap = 0;
          clickThrough = false;
          dot = true;
          enabled = false;
          followInterfaceStyle = false;
          fontScale = 1;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          gothCornersEnabled = false;
          hoverPopoutDelay = 150;
          hoverPopouts = true;
          id = "dot1791752776859";
          innerPadding = 4;
          island = false;
          islandAlongOffset = 0;
          islandCompactThickness = 38;
          islandFloating = false;
          islandHighContrast = false;
          islandHomeCompactTight = false;
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
          islandReserveThickness = 0;
          islandRouteClipboard = "island";
          islandRouteControlCenter = "bar";
          islandRouteLauncher = "island";
          islandRouteNotificationCenter = "island";
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
          name = "Dot";
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
          surfaceColor = "default";
          surfaceCustomColor = "#25003b";
          transparency = 0.9;
          visible = true;
          widgetFollowInterfaceStyle = true;
          widgetOutlineColor = "primary";
          widgetOutlineEnabled = false;
          widgetOutlineOpacity = 1;
          widgetOutlineThickness = 1;
          widgetPadding = 5;
          widgetStyle = "pills";
          widgetTransparency = 1;
        }
      ];
    };
  };
}
