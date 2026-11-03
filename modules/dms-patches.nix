# Patches the DMS package. The island bar in dms-settings gets smaller gaps between its home
# groups and at its ends, and separate gaps around the clock. Its clock gets a fixed size and
# weight, its weather icon a fixed size and a small lift, its temperature digits sit on the
# center line, and its slots open on hover. It also draws the dash metric sparklines behind the
# text, polls system stats every 1s with the dash closed too, and sets the dash clock font. A
# dash opened from a right-side bar mirrors its overview cards.
# All of these live in DMS's QML with no setting. The patch uses --replace-fail, so a DMS
# update that moves those lines fails the build. Needs the dank-material-shell home module.
{ options, ... }:
let
  # Gaps in the vertical island, in px. DMS uses Theme.spacingM (12px) for all of them and has no
  # setting; "Compact" also shrinks text and slots. islandGroupGap is the gap between groups,
  # except next to the clock, which has its own gap above (media) and below (weather).
  # islandEdgeGapTop and islandEdgeGapBottom are the space between the first and last group and
  # the island's ends.
  islandGroupGap = 4;
  islandClockGapAbove = 4;
  islandClockGapBelow = 2;
  islandEdgeGapTop = 8;
  islandEdgeGapBottom = 6;
  # Island clock and date in px, independent of fontScale (14 is fontSizeMedium at scale 1).
  islandClockFontSize = 14;
  islandClockFontWeight = 900;
  # Island weather icon in px. DMS sizes it as the text size plus 2, so fontScale 0.85 gives 14.
  # The temperature below it is padded left by the width of its trailing "°", so the digits sit
  # on the center line.
  islandWeatherIconSize = 20;
  # Moves the island's weather icon and temperature up, in px. The groups' boxes are islandGroupGap
  # apart, but the icon's own padding makes the visible gap above it larger than the clock's gaps.
  islandWeatherLift = 0;
  # Dash clock card digits. "Google Sans Flex" equals DMS's defaultFontFamily, so DClockFace uses
  # the variable face and sets the weight (dashOptions.clock.weight in dms-settings) through its
  # wght axis. Any other family gets a static face.
  dashClockFontFamily = "Google Sans Flex";
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
                leftPadding: degreeMetrics.advanceWidth

                TextMetrics {
                    id: degreeMetrics
                    font: islandTempText.font
                    text: \"°\"
                }" \
          --replace-fail \
            "acceptedButtons: group.isTray ? Qt.NoButton : (Qt.LeftButton | Qt.MiddleButton)" \
            "acceptedButtons: group.isTray ? Qt.NoButton : (Qt.LeftButton | Qt.MiddleButton)

                Timer {
                    running: slotArea.containsMouse && !slotArea.group.isWorkspaces && !slotArea.group.isTray && (!slotArea.group.isMedia || root.controller.mediaAvailable)
                    interval: root.controller.hoverOpenDelay
                    onTriggered: {
                        const groupId = slotArea.group.groupId;
                        switch (groupId) {
                        case \"media\":
                        case \"weather\":
                            root.controller.requestHoverPeek(groupId);
                            return;
                        case \"notifications\":
                            root.controller.consumeTransientNotification();
                            root.controller.requestHoverPeek(\"notificationcenter\");
                            return;
                        case \"volume\":
                        case \"brightness\":
                            root.systemModel.open(groupId);
                            return;
                        }
                        // The control center opens on the section a click last asked for.
                        root.controller.controlCenterPendingSection = groupId === \"privacy\" ? \"audioInput\" : \"\";
                        root.controller.requestHoverPeek(\"controlcenter\");
                    }
                }"

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

        # Hovering an island slot opens what a click on it opens, as a hover peek, the way hybrid
        # mode peeks the home view. hoverExpanded makes the existing close timer collapse it when
        # the pointer leaves the island. Without keyboard focus the peek does not take input from
        # the focused window. A click still opens it pinned with focus. Expanding leaves
        # mediaPreferred alone, so the island returns to the face picked with a right-click.
        # Volume and brightness open their slider, which closes on its own timeout. Workspaces and
        # tray have no view, and the media slot without a player would open the launcher, which
        # needs focus, so those three stay click-only.
        substituteInPlace $out/share/quickshell/dms/Modules/DIsland/IslandController.qml \
          --replace-fail \
            "    function requestNotificationCenter(shouldToggle) {" \
            "    function requestHoverPeek(activityId) {
                if (inputSuspended || !hoverExpandEnabled || expanded)
                    return false;
                if (!requestActivity(activityId, true, false))
                    return false;
                hoverExpanded = true;
                return true;
            }

            function requestNotificationCenter(shouldToggle) {" \
          --replace-fail \
            "            slotHoverCount = 0;" \
            "            slotHoverCount = 0;
                    // A hover peek whose visuals were still loading must not open after the pointer left.
                    if (hoverExpanded && !expanded) {
                        hoverExpanded = false;
                        clearPendingRequests(\"\");
                    }"

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

        # A dash opened from a right-side bar mirrors its overview cards, so the first column sits
        # at the screen edge on either side. DMS only mirrors them for right-to-left languages. The
        # cards' contents keep their direction. The grid already handles a mirrored layout when
        # dragging; keyboard order and resizing read I18n.isRtl directly, so they follow the flag too.
        # The popout passes the bar through dashHost. The island's expanded home embeds the
        # overview without a popout, so it sets rightEdge from its own edge.
        substituteInPlace $out/share/quickshell/dms/Modules/DDash/OverviewTab.qml \
          --replace-fail \
            "property string preferredFocusId: \"calendar\"" \
            "property string preferredFocusId: \"calendar\"
            property var dashHost: null
            property bool rightEdge: (dashHost?.effectiveBarPosition ?? 0) % 4 === SettingsData.Right
            readonly property bool mirrorCards: I18n.isRtl !== rightEdge" \
          --replace-fail \
            "columnCap: root.columnCap" \
            "columnCap: root.columnCap
                mirror: root.mirrorCards"
        substituteInPlace $out/share/quickshell/dms/Modules/DIsland/Activities/HomeExpanded.qml \
          --replace-fail \
            "rowBudget: root.controller.dashboardRowBudget" \
            "rowBudget: root.controller.dashboardRowBudget
                rightEdge: root.controller.edge === \"right\""
        substituteInPlace $out/share/quickshell/dms/Modules/DDash/Overview/DashCardGrid.qml \
          --replace-fail \
            "property string preferredFocusId: \"calendar\"" \
            "property string preferredFocusId: \"calendar\"
            property bool mirror: I18n.isRtl" \
          --replace-fail \
            "DashMetrics.gridRowUnit, I18n.isRtl, DashRegistry.isCardAvailable" \
            "DashMetrics.gridRowUnit, root.mirror, DashRegistry.isCardAvailable" \
          --replace-fail \
            "(I18n.isRtl ? b.x - a.x : a.x - b.x)" \
            "(root.mirror ? b.x - a.x : a.x - b.x)"
        substituteInPlace $out/share/quickshell/dms/Widgets/DEditableGridSlot.qml \
          --replace-fail \
            "(point.x - resizeOrigin.x) * (I18n.isRtl ? -1 : 1)" \
            "(point.x - resizeOrigin.x) * ((grid.slotLayout.mirror ?? I18n.isRtl) ? -1 : 1)"
      '';
    });
  };
}
