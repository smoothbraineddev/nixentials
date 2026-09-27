{ ... }:
let
  c = import ../lib/colors.nix;

  zenThemeCss = ''
    /* ===== SMOOTHBRAINED ZEN THEME ===== */
    /* Self-contained custom theme, no DMS/matugen dependency.                */
    /* Sources colors from colors.nix via Nix interpolation at build time.    */
    /* Sets both Zen-native and MD3 variable namespaces unconditionally.      */

    :root {
      /* --- Zen-native variables --- */
      --zen-primary-color: ${c.md3.primary_container} !important;
      --zen-themed-toolbar-bg-transparent: ${c.md3.surface_container_lowest} !important;
      --zen-main-browser-background: ${c.md3.surface_container_lowest} !important;
      --zen-main-browser-background-toolbar: ${c.md3.surface_container_lowest} !important;
      --toolbar-bgcolor: ${c.md3.surface_container_lowest} !important;
      --zen-browser-border-radius: 0 !important;
      --zen-element-separation: 0px !important;

      /* --- Firefox chrome variables --- */
      --toolbarbutton-icon-fill: ${c.md3.primary} !important;
      --toolbar-field-color: ${c.md3.on_surface} !important;
      --tab-selected-textcolor: ${c.md3.on_surface} !important;
      --toolbar-color: ${c.md3.on_surface} !important;
      --arrowpanel-color: ${c.md3.on_surface} !important;
      --arrowpanel-background: ${c.md3.surface_container_high} !important;
      --sidebar-text-color: ${c.md3.on_surface} !important;

      /* --- Firefox in-content accent (settings page toggles, checkboxes) --- */
      --in-content-accent-color: ${c.md3.primary} !important;
      --in-content-accent-color-active: ${c.md3.primary_fixed_dim} !important;
      --in-content-page-background: ${c.md3.surface_container_lowest} !important;

      /* --- MD3 semantic color tokens --- */
      --md-sys-color-primary: ${c.md3.primary};
      --md-sys-color-surface-tint: ${c.md3.surface_tint};
      --md-sys-color-on-primary: ${c.md3.on_primary};
      --md-sys-color-primary-container: ${c.md3.primary_container};
      --md-sys-color-on-primary-container: ${c.md3.on_primary_container};
      --md-sys-color-secondary: ${c.md3.secondary};
      --md-sys-color-on-secondary: ${c.md3.on_secondary};
      --md-sys-color-secondary-container: ${c.md3.secondary_container};
      --md-sys-color-on-secondary-container: ${c.md3.on_secondary_container};
      --md-sys-color-tertiary: ${c.md3.tertiary};
      --md-sys-color-on-tertiary: ${c.md3.on_tertiary};
      --md-sys-color-tertiary-container: ${c.md3.tertiary_container};
      --md-sys-color-on-tertiary-container: ${c.md3.on_tertiary_container};
      --md-sys-color-error: ${c.md3.error};
      --md-sys-color-on-error: ${c.md3.on_error};
      --md-sys-color-error-container: ${c.md3.error_container};
      --md-sys-color-on-error-container: ${c.md3.on_error_container};
      --md-sys-color-background: ${c.md3.surface_container_lowest};
      --md-sys-color-on-background: ${c.md3.on_background};
      --md-sys-color-surface: ${c.md3.surface_container_lowest};
      --md-sys-color-on-surface: ${c.md3.on_surface};
      --md-sys-color-surface-variant: ${c.md3.surface_variant};
      --md-sys-color-on-surface-variant: ${c.md3.on_surface_variant};
      --md-sys-color-outline: ${c.md3.outline};
      --md-sys-color-outline-variant: ${c.md3.outline_variant};
      --md-sys-color-shadow: ${c.md3.shadow};
      --md-sys-color-scrim: ${c.md3.scrim};
      --md-sys-color-inverse-surface: ${c.md3.inverse_surface};
      --md-sys-color-inverse-on-surface: ${c.md3.inverse_on_surface};
      --md-sys-color-inverse-primary: ${c.md3.inverse_primary};
      --md-sys-color-primary-fixed: ${c.md3.primary_fixed};
      --md-sys-color-on-primary-fixed: ${c.md3.on_primary_fixed};
      --md-sys-color-primary-fixed-dim: ${c.md3.primary_fixed_dim};
      --md-sys-color-on-primary-fixed-variant: ${c.md3.on_primary_fixed_variant};
      --md-sys-color-secondary-fixed: ${c.md3.secondary_fixed};
      --md-sys-color-on-secondary-fixed: ${c.md3.on_secondary_fixed};
      --md-sys-color-secondary-fixed-dim: ${c.md3.secondary_fixed_dim};
      --md-sys-color-on-secondary-fixed-variant: ${c.md3.on_secondary_fixed_variant};
      --md-sys-color-tertiary-fixed: ${c.md3.tertiary_fixed};
      --md-sys-color-on-tertiary-fixed: ${c.md3.on_tertiary_fixed};
      --md-sys-color-tertiary-fixed-dim: ${c.md3.tertiary_fixed_dim};
      --md-sys-color-on-tertiary-fixed-variant: ${c.md3.on_tertiary_fixed_variant};
      --md-sys-color-surface-dim: ${c.md3.surface_container_lowest};
      --md-sys-color-surface-bright: ${c.md3.surface_bright};
      --md-sys-color-surface-container-lowest: ${c.md3.surface_container_lowest};
      --md-sys-color-surface-container-low: ${c.md3.surface_container_low};
      --md-sys-color-surface-container: ${c.md3.surface_container_lowest};
      --md-sys-color-surface-container-high: ${c.md3.surface_container_high};
      --md-sys-color-surface-container-highest: ${c.md3.surface_container_highest};

      /* --- Elevation & interaction --- */
      --m3-elev-1: 0 1px 2px rgba(0,0,0,.50), 0 1px 3px rgba(0,0,0,.35);
      --m3-elev-2: 0 4px 10px rgba(0,0,0,.55), 0 1px 3px rgba(0,0,0,.35);
      --state-hover: color-mix(in srgb, var(--md-sys-color-on-surface) 6%, transparent);
      --state-press: color-mix(in srgb, var(--md-sys-color-on-surface) 10%, transparent);
      --focus-ring: 0 0 0 2px color-mix(in srgb, var(--md-sys-color-primary) 70%, transparent);

      /* --- Font --- */
      font-family: system-ui, "Inter Variable", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji" !important;
    }

    /* ===== TOOLBOX BACKGROUND (JS inline override) ===== */
    /* ZenGradientGenerator sets these inline, so override on the elements */
    #zen-browser-background {
      --zen-main-browser-background: ${c.md3.surface_container_lowest} !important;
    }
    #zen-toolbar-background {
      --zen-main-browser-background-toolbar: ${c.md3.surface_container_lowest} !important;
    }

    /* ===== CHROME UI ELEMENTS ===== */
    .sidebar-placesTree {
      background-color: ${c.md3.surface_container_high} !important;
    }

    #zen-workspaces-button {
      background-color: ${c.md3.surface_container_lowest} !important;
    }

    #TabsToolbar {
      background-color: ${c.md3.surface_container_lowest} !important;
    }

    .urlbar-background {
      background-color: ${c.md3.surface_container_high} !important;
    }

    .urlbar-input::selection {
      color: ${c.md3.on_primary} !important;
      background-color: ${c.md3.primary} !important;
    }

    .urlbarView-url {
      color: ${c.md3.on_surface_variant} !important;
    }

    toolbar .toolbarbutton-1 {
      &:not([disabled]) {
        &:is([open], [checked])
          > :is(
            .toolbarbutton-icon,
            .toolbarbutton-text,
            .toolbarbutton-badge-stack
          ) {
          fill: ${c.md3.primary}
        }
      }
    }

    #zen-appcontent-navbar-container {
      background-color: ${c.md3.surface_container_lowest} !important;
    }

    /* ===== POPUP / MENU HOVER ===== */
    /* Set the Tidy Popup mod's custom color variable so both mod + theme agree */
    :root {
      --mod-tidypopup-hovercolor: color-mix(in srgb, ${c.md3.primary} 75%, black) !important;
    }
    :is(panelview .toolbarbutton-1, toolbarbutton.subviewbutton, .widget-overflow-list .toolbarbutton-1, .toolbaritem-combined-buttons:is(:not([cui-areatype="toolbar"]), [overflowedItem="true"]) > toolbarbutton) {
      &:not([disabled]):hover {
        background-color: color-mix(in srgb, ${c.md3.primary} 75%, black) !important;
      }
    }
    menu:not([disabled]):hover,
    menuitem:not([disabled]):hover,
    menucaption:not([disabled]):hover {
      background-color: ${c.md3.primary} !important;
    }

    /* ===== CONTAINER IDENTITY COLORS ===== */
    .identity-color-blue {
      --identity-tab-color: ${c.smoothbrained.bright_gold} !important;
      --identity-icon-color: ${c.smoothbrained.bright_gold} !important;
    }
    .identity-color-turquoise {
      --identity-tab-color: ${c.md3.primary} !important;
      --identity-icon-color: ${c.md3.primary} !important;
    }
    .identity-color-green {
      --identity-tab-color: ${c.smoothbrained.lime} !important;
      --identity-icon-color: ${c.smoothbrained.lime} !important;
    }
    .identity-color-yellow {
      --identity-tab-color: ${c.smoothbrained.warm_cream} !important;
      --identity-icon-color: ${c.smoothbrained.warm_cream} !important;
    }
    .identity-color-orange {
      --identity-tab-color: ${c.smoothbrained.warm_tan} !important;
      --identity-icon-color: ${c.smoothbrained.warm_tan} !important;
    }
    .identity-color-red {
      --identity-tab-color: ${c.smoothbrained.pink} !important;
      --identity-icon-color: ${c.smoothbrained.pink} !important;
    }
    .identity-color-pink {
      --identity-tab-color: ${c.smoothbrained.rust} !important;
      --identity-icon-color: ${c.smoothbrained.rust} !important;
    }
    .identity-color-purple {
      --identity-tab-color: ${c.smoothbrained.brown} !important;
      --identity-icon-color: ${c.smoothbrained.brown} !important;
    }

    /* ===== HIDE STATUS BAR AFTER PAGE LOAD ===== */
    @keyframes statusFadeOut {
      0%   { opacity: 1; }
      100% { opacity: 0; }
    }
    #statuspanel #statuspanel-label {
      animation: statusFadeOut 0.4s ease 5s forwards !important;
    }

    /* ===== FLOATING HISTORY GHOST OUTLINE FIX ===== */
    #sidebar-box[hidden="true"] {
      visibility: hidden !important;
      opacity: 0 !important;
    }

    /* ===== BORDERLESS CONTENT AREA ===== */
    #zen-main-app-wrapper {
      padding: 0 !important;
      background-color: ${c.md3.surface_container_lowest} !important;
    }
    #appcontent,
    #tabbrowser-tabpanels,
    .browserContainer {
      border-radius: 0 !important;
      border: none !important;
      outline: none !important;
    }
  '';

in
{
  xdg.configFile."zen/customTheme.css".text = zenThemeCss;
}
