# Patches the DMS package for the island bar in dms-settings: a smaller gap between
# the island's home groups, and a fixed size and weight for its clock. It also draws the
# dash metric sparklines behind the text and polls system stats every 1s. All of these live in
# DMS's QML with no setting. The patch uses --replace-fail, so a DMS update that
# moves those lines fails the build. Needs the dank-material-shell home module.
{ options, ... }:
let
  # Gap between the island's home groups (media, clock, weather). DMS uses
  # Theme.spacingM (12px) with no setting for it; "Compact" also shrinks text and slots.
  islandGroupGap = 6;
  # Island clock and date in px, independent of fontScale (14 is fontSizeMedium at scale 1).
  islandClockFontSize = 14;
  islandClockFontWeight = 800;
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
                availableWidth: root.width"

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
        substituteInPlace $out/share/quickshell/dms/Services/DgopService.qml \
          --replace-fail \
            "updateInterval: powerSaver ? 6000 : 3000" \
            "updateInterval: powerSaver ? 3000 : 1000" \
          --replace-fail \
            "interval: 1000" \
            "interval: 250"
      '';
    });
  };
}
