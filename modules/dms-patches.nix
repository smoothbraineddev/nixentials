# Patches the DMS package. The island bar in dms-settings gets its own corner radius, smaller
# gaps between its home groups and at its ends, and separate gaps around the clock. Its clock gets a fixed size and
# weight, its weather icon a fixed size and a small lift, and its temperature digits sit on
# the center line. It also draws the dash metric sparklines behind the
# text, polls system stats every 1s with the dash closed too, and sets the dash clock font.
# Click-through desktop widgets move to the background layer, which niri/misc.nix puts in the
# backdrop. The lock screen wallpaper gets no blur.
# All of these live in DMS's QML with no setting. The patch uses --replace-fail, so a DMS
# update that moves those lines fails the build. Needs the dank-material-shell home module.
{ options, ... }:
let
  # Gaps in the vertical island, in px. DMS uses Theme.spacingM (12px) for all of them and has no
  # setting; "Compact" also shrinks text and slots. islandGroupGap is the gap between groups,
  # except next to the clock, which has its own gap above (media) and below (weather).
  # islandEdgeGapTop and islandEdgeGapBottom are the space between the first and last group and
  # the island's ends.
  islandGroupGap = 0;
  islandClockGapAbove = 2;
  islandClockGapBelow = 2;
  islandEdgeGapTop = 8;
  islandEdgeGapBottom = 5;
  # Island corners in px: the expanded views, the compact face and the flare where the notch
  # meets the screen edge. DMS uses Theme.windowRadius for the views and the flare, and a pill
  # radius for the face, which pillTarget caps at half the island's thickness.
  islandCornerRadius = 12;
  # Island clock and date in px, independent of fontScale (14 is fontSizeMedium at scale 1).
  islandClockFontSize = 13;
  islandClockFontWeight = 900;
  # Island weather icon in px. DMS sizes it as the text size plus 2, so fontScale 0.85 gives 14.
  # The temperature below it is padded left by the width of its trailing "°", so the digits sit
  # on the center line.
  islandWeatherIconSize = 16;
  # Moves the island's weather icon and temperature up, in px. The groups' boxes are islandGroupGap
  # apart, but the icon's own padding makes the visible gap above it larger than the clock's gaps.
  islandWeatherLift = 0;
  # Moves the island's temperature right, in px, after the "°" padding has centered its digits.
  # The Grid centers the padded text, so the padding changes by twice this.
  islandTempShift = -1;
  # Dash clock card digits. "Google Sans Flex" equals DMS's defaultFontFamily, so DClockFace uses
  # the variable face and sets the weight (dashOptions.clock.weight in dms-settings) through its
  # wght axis. Any other family gets a static face.
  dashClockFontFamily = "Google Sans Flex";
  # Lock screen wallpaper blur, 0 to 1. DMS uses 0.8. The 40% dark scrim over the wallpaper
  # (Theme.lockScreenScrimAlpha) stays, so the clock and password field stay readable.
  lockScreenBlur = 0;
in
{
  programs.dank-material-shell = {
    package = options.programs.dank-material-shell.package.default.overrideAttrs (old: {
      postInstall = old.postInstall + ''
        substituteInPlace $out/share/quickshell/dms/Modules/DIsland/Activities/HomeCompact.qml \
          --replace-fail \
            "spacing: root.groupSpacing" \
            "spacing: ${toString islandGroupGap}" \
          --replace-fail \
            ": root.groupSpacing / 2" \
            ": ${toString islandGroupGap} / 2" \
          --replace-fail \
            "fontSize: root.textSize
                availableWidth: root.width" \
            "fontSize: ${toString islandClockFontSize}
                fontWeight: ${toString islandClockFontWeight}
                availableWidth: root.width" \
          --replace-fail \
            "name: WeatherService.getWeatherIcon(WeatherService.weather.wCode)
                        size: root.statusIconSize" \
            "name: WeatherService.getWeatherIcon(WeatherService.weather.wCode)
                        size: ${toString islandWeatherIconSize}" \
          --replace-fail \
            "id: content

                    anchors.centerIn: parent" \
            "id: content

                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: (group.clockLead - group.clockTrail) / 2 - (group.vertical && group.isWeather ? ${toString islandWeatherLift} : 0)" \
          --replace-fail \
            "readonly property bool isClock: group.groupId === \"clock\"" \
            "readonly property bool isClock: group.groupId === \"clock\"
                readonly property real clockLead: group.vertical && group.isClock && group.slotIndex > 0 ? ${toString islandClockGapAbove} - ${toString islandGroupGap} : 0
                readonly property real clockTrail: group.vertical && group.isClock && group.slotIndex < root.groupIds.length - 1 ? ${toString islandClockGapBelow} - ${toString islandGroupGap} : 0" \
          --replace-fail \
            "height: group.vertical ? content.implicitHeight : root.slotSize" \
            "height: group.vertical ? content.implicitHeight + group.clockLead + group.clockTrail : root.slotSize" \
          --replace-fail \
            "text: WeatherService.currentTempText()" \
            "text: WeatherService.currentTempText()
                id: islandTempText
                leftPadding: degreeMetrics.advanceWidth + 2 * ${toString islandTempShift}

                TextMetrics {
                    id: degreeMetrics
                    font: islandTempText.font
                    text: \"°\"
                }"

        substituteInPlace $out/share/quickshell/dms/Modules/DIsland/IslandBarHost.qml \
          --replace-fail \
            "cornerRadius: root.connectedChrome ? Theme.connectedSurfaceRadius : Theme.windowRadius" \
            "cornerRadius: ${toString islandCornerRadius}" \
          --replace-fail \
            "pillRadius: BarMetrics.pillRadius(root.compactThickness, root.barConfig?.widgetStyle ?? \"pills\")" \
            "pillRadius: ${toString islandCornerRadius}" \
          --replace-fail \
            "notchRadius: BarMetrics.gothRadius(root.barConfig)" \
            "notchRadius: ${toString islandCornerRadius}"

        # homeSlotMargin pads both ends of the island equally, so it takes the mean of the two edge
        # gaps and the column moves by half their difference. HomeCompact's groupSpacing, now read
        # only by edgePad, follows it.
        substituteInPlace $out/share/quickshell/dms/Modules/DIsland/IslandController.qml \
          --replace-fail \
            "readonly property real homeSlotMargin: homeCompactTight ? Theme.spacingS : Theme.spacingM" \
            "readonly property real homeSlotMargin: (${toString islandEdgeGapTop} + ${toString islandEdgeGapBottom}) / 2"
        substituteInPlace $out/share/quickshell/dms/Modules/DIsland/Activities/HomeCompact.qml \
          --replace-fail \
            "id: compactColumn

                anchors.centerIn: parent" \
            "id: compactColumn

                anchors.centerIn: parent
                anchors.verticalCenterOffset: (${toString islandEdgeGapTop} - ${toString islandEdgeGapBottom}) / 2"

        # ClockContent has no weight property; 0 keeps the global weight for the bar clock.
        substituteInPlace $out/share/quickshell/dms/Widgets/ClockContent.qml \
          --replace-fail \
            "property real fontSize: Theme.fontSizeMedium" \
            "property real fontSize: Theme.fontSizeMedium
            property int fontWeight: 0" \
          --replace-fail \
            "font.pixelSize: root.fontSize" \
            "font.pixelSize: root.fontSize
                        font.weight: root.fontWeight > 0 ? root.fontWeight : Theme.fontWeight"

        # Wide dash metric tiles: draw the sparkline behind the text across the whole card width
        # and the bottom two-thirds, instead of the bottom 45% right of the value. y stays bottom-aligned.
        # historyLength fixes the x step to a full buffer, so a short history (network and disk
        # restart empty on each open) grows in from the right instead of stretching across the tile.
        substituteInPlace $out/share/quickshell/dms/Modules/DDash/Overview/MetricCard.qml \
          --replace-fail \
            "anchors.left: root.wide ? valueText.right : parent.left" \
            "anchors.left: parent.left" \
          --replace-fail \
            "anchors.leftMargin: root.wide ? Theme.spacingM : -root.pad" \
            "anchors.leftMargin: -root.pad" \
          --replace-fail \
            "anchors.rightMargin: root.wide ? 0 : -root.pad" \
            "anchors.rightMargin: -root.pad" \
          --replace-fail \
            "height: root.wide ? root.height * DashMetrics.tileTrendRatio" \
            "height: root.wide ? root.height * 2 / 3" \
          --replace-fail \
            "insetBottom: root.wide ? root.pad : lineWidth" \
            "insetTop: root.wide ? root.pad : lineWidth
                insetBottom: root.wide ? root.pad : lineWidth
                historyLength: DgopService.historySize"

        # Poll system stats every 1s instead of 3s (6s on power saver), and fetch the second
        # sample 250ms after a dash card subscribes instead of 1s, so network and disk rates show sooner.
        # A permanent ref keeps the dash metrics polling with the dash closed. Without it, closing
        # the dash drops the module and releaseUnusedData() clears its history.
        substituteInPlace $out/share/quickshell/dms/Services/DgopService.qml \
          --replace-fail \
            "updateInterval: powerSaver ? 6000 : 3000" \
            "updateInterval: powerSaver ? 3000 : 1000" \
          --replace-fail \
            "interval: 1000" \
            "interval: 250" \
          --replace-fail \
            "    onDgopAvailableChanged: {" \
            "    Component.onCompleted: addRef([\"cpu\", \"memory\", \"network\", \"disk\"])${"\n\n    "}onDgopAvailableChanged: {"

        # DClockFace has fontFamily and rounded properties that ClockCard does not set. rounded: false
        # sets the font's ROND axis to 20 (squarer corners) instead of 100.
        substituteInPlace $out/share/quickshell/dms/Modules/DDash/Overview/ClockCard.qml \
          --replace-fail \
            "DClockFace {" \
            "DClockFace {
                    fontFamily: \"${dashClockFontFamily}\"
                    rounded: false"

        # Click-through desktop widgets go on the background layer, so niri's place-within-backdrop
        # rule in niri/misc.nix can put them in the backdrop with the wallpaper. On the bottom layer
        # niri draws them on every workspace and moves them with it. The backdrop takes no input,
        # so a widget that is not click-through stays on the bottom layer, where it can be dragged.
        substituteInPlace $out/share/quickshell/dms/Modules/Plugins/DesktopPluginWrapper.qml \
          --replace-fail \
            "            return WlrLayer.Bottom;" \
            "            return root.clickThrough ? WlrLayer.Background : WlrLayer.Bottom;"

        substituteInPlace $out/share/quickshell/dms/Common/Theme.qml \
          --replace-fail \
            "readonly property real lockScreenBlur: 0.8" \
            "readonly property real lockScreenBlur: ${toString lockScreenBlur}"
      '';
    });
  };
}
