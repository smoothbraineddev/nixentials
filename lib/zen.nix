# Zen prefs, mods and policies shipped as data, for the same reason as ./niri.nix. The
# profile has one user.js, so a consumer that wants other prefs builds its own file
# from `toUserJs (allPrefs // { ... })`, or from the groups it wants, instead of
# importing homeModules.zen-profile. The privacy prefs, the add-ons and the renderer are
# ./firefox.nix's, shared with other Firefox-based browsers.
#
let
  firefox = import ./firefox.nix;

  prefs = {
    core = {
      # Switches on chrome/userChrome.css, which is where the theme loads from.
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      "zen.welcome-screen.seen" = true;
    };

    inherit (firefox.prefs) privacy;

    layout = {
      "sidebar.visibility" = "hide-sidebar";

      "zen.urlbar.behavior" = "float";
      "zen.view.compact.enable-at-startup" = true;
      "zen.view.compact.toolbar-flash-popup" = true;
      # Default 150 ms; the sidebar stays open this long after the pointer leaves it.
      "zen.view.compact.sidebar-keep-hover.duration" = 400;
      "zen.view.show-newtab-button-top" = false;
      "zen.view.window.scheme" = 0;
      "zen.tabs.show-newtab-vertical" = false;
      "zen.swipe.is-fast-swipe" = false;

      "zen.workspaces.continue-where-left-off" = true;
      "zen.workspaces.force-container-workspace" = true;
      "zen.workspaces.show-workspace-indicator" = false;
      "zen.workspaces.indicator-position" = "";
      "zen.workspaces.indicator-name-center" = false;
      "zen.window-sync.sync-only-pinned-tabs" = true;
    };

    # Settings of the mods below. Each key is declared in that mod's preferences.json.
    mods = {
      "zen.themes.disable-all" = false;

      # Better Find Bar
      "theme-better_find_bar-enable_custom_background" = true;
      "theme.better_find_bar.custom_background" = "#0e0e0e";
      "theme.better_find_bar.hide_find_status" = false;
      "theme.better_find_bar.hide_found_matches" = false;
      "theme.better_find_bar.hide_highlight" = "not_hide";
      "theme.better_find_bar.hide_match_case" = "not_hide";
      "theme.better_find_bar.hide_match_diacritics" = "not_hide";
      "theme.better_find_bar.hide_whole_words" = "not_hide";
      "theme.better_find_bar.horizontal_position" = "default";
      "theme.better_find_bar.instant_animations" = false;
      "theme.better_find_bar.textbox_width" = "800";
      "theme.better_find_bar.transparent_background" = true;
      "theme.better_find_bar.vertical_position" = "default";

      # Better CtrlTab Panel
      "psu.better_ctrltab.background" = "light-dark(rgba(144, 144, 144, 0.94), rgba(22, 22, 22, 0.92))";
      "psu.better_ctrltab.padding" = "16px";
      "psu.better_ctrltab.preview_border_color" =
        "light-dark(rgba(255, 255, 255, 0.1), rgba(1, 1, 1, 0.1))";
      "psu.better_ctrltab.preview_border_width" = "1px";
      "psu.better_ctrltab.preview_favicon_outdent" = "12px";
      "psu.better_ctrltab.preview_favicon_size" = "36px";
      "psu.better_ctrltab.preview_focus_background" =
        "light-dark(rgba(77, 77, 77, 0.8), rgba(204, 204, 204, 0.33))";
      "psu.better_ctrltab.preview_font_size" = "13px";
      "psu.better_ctrltab.preview_letter_spacing" = "0px";
      "psu.better_ctrltab.roundness" = "28px";
      "psu.better_ctrltab.shadow_size" = "18px";
      "psu.better_ctrltab.zoom" = "0.8";

      # Tidy Popup
      "mod.tidypopup.usecustomhovercolor" = true;

      # Floating History
      "theme.floating_history.position" = "left";
    };
  };
in
{
  inherit prefs;

  # Everything, for the convenience module. No key appears in two groups.
  allPrefs = builtins.foldl' (a: b: a // b) { } (builtins.attrValues prefs);

  # Mods from github:zen-browser/theme-store, keyed by the directory name under themes/.
  # homeModules.zen-profile copies them out of a pinned checkout of that repo.
  mods = {
    "a6335949-4465-4b71-926c-4a52d34bc9c0" = "Better Find Bar";
    "72f8f48d-86b9-4487-acea-eb4977b18f21" = "Better CtrlTab Panel";
    "f7c71d9a-bce2-420f-ae44-a64bd92975ab" = "Better Unloaded Tabs";
    "906c6915-5677-48ff-9bfc-096a02a72379" = "Floating Status Bar";
    "79dde383-4fe7-404a-a8e6-9be440022542" = "Tidy Popup";
    "253a3a74-0cc4-47b7-8b82-996a64f030d5" = "Floating History";
    "b0f635d7-c3bf-4709-af68-4712f0e5b2e5" = "Cleaner Bookmark Menu";
    "599a1599-e6ab-4749-ab22-de533860de2c" = "Pimp your PiP";
  };

  # Enterprise policies for the Zen package, which installs these add-ons from AMO. The
  # consumer passes them to wrapFirefox as `extraPolicies` (see the README).
  policies = firefox.extensionPolicies (
    with firefox.addons;
    [
      bitwarden
      darkreader
      noscript
      ublock
    ]
  );

  inherit (firefox) toUserJs;
}
