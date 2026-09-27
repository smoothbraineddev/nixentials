# Niri config shipped as data, not only as modules.
#
# `programs.niri.settings.binds` is an attrset keyed on the bind string and
# `window-rules` is a list. If this flake set those options directly, a consumer
# wanting a different action on one of our binds would be defining the same leaf
# twice and would need `lib.mkForce`.
#
# Exporting the groups as data avoids that: `//` is right-biased and `++` is
# concatenation, so a consumer composing from here can override or drop anything
# with no mkForce at all.
#
let
  cornerRadius = r: {
    top-left = r;
    top-right = r;
    bottom-right = r;
    bottom-left = r;
  };

  binds = {
    # System & Overview
    overview = {
      "Mod+Tab" = {
        repeat = false;
        action.toggle-overview = { };
      };
      "Mod+Shift+Slash".action.show-hotkey-overlay = { };
    };

    # Spawn Terminal
    terminal = {
      "Mod+Return" = {
        hotkey-overlay.title = "Open Terminal";
        action.spawn = "wezterm";
      };
    };

    # Security.
    lock = {
      "Mod+Shift+E" = {
        hotkey-overlay.title = "Exit niri";
        action.quit = { };
      };
      "Ctrl+Alt+L" = {
        hotkey-overlay.title = "Lock Screen";
        action.spawn = [
          "loginctl"
          "lock-session"
        ];
      };
    };

    # Window Management
    windows = {
      "Mod+Q" = {
        repeat = false;
        action.close-window = { };
      };
      "Mod+F".action.maximize-column = { };
      "Mod+Shift+F".action.fullscreen-window = { };
      "Mod+Shift+G".action.toggle-window-floating = { };
      "Mod+G".action.switch-focus-between-floating-and-tiling = { };
      "Mod+S".action.toggle-column-tabbed-display = { };
    };

    # Focus Navigation
    focus = {
      "Mod+H".action.focus-column-or-monitor-left = { };
      "Mod+J".action.focus-window-or-workspace-down = { };
      "Mod+K".action.focus-window-or-workspace-up = { };
      "Mod+L".action.focus-column-or-monitor-right = { };

      "Mod+Left".action.focus-column-or-monitor-left = { };
      "Mod+Down".action.focus-window-or-workspace-down = { };
      "Mod+Up".action.focus-window-or-workspace-up = { };
      "Mod+Right".action.focus-column-or-monitor-right = { };
    };

    # Window Movement
    movement = {
      "Mod+Shift+H".action.move-column-left-or-to-monitor-left = { };
      "Mod+Shift+J".action.move-window-down-or-to-workspace-down = { };
      "Mod+Shift+K".action.move-window-up-or-to-workspace-up = { };
      "Mod+Shift+L".action.move-column-right-or-to-monitor-right = { };

      "Mod+Shift+Left".action.move-column-left-or-to-monitor-left = { };
      "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = { };
      "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = { };
      "Mod+Shift+Right".action.move-column-right-or-to-monitor-right = { };
    };

    # Column Navigation
    columns = {
      "Mod+Home".action.focus-column-first = { };
      "Mod+End".action.focus-column-last = { };
      "Mod+Ctrl+Home".action.move-column-to-first = { };
      "Mod+Ctrl+End".action.move-column-to-last = { };
    };

    # Monitor Navigation
    monitors = {
      "Mod+Ctrl+H".action.focus-monitor-left = { };
      "Mod+Ctrl+J".action.focus-monitor-down = { };
      "Mod+Ctrl+K".action.focus-monitor-up = { };
      "Mod+Ctrl+L".action.focus-monitor-right = { };

      "Mod+Ctrl+Left".action.focus-monitor-left = { };
      "Mod+Ctrl+Down".action.focus-monitor-down = { };
      "Mod+Ctrl+Up".action.focus-monitor-up = { };
      "Mod+Ctrl+Right".action.focus-monitor-right = { };

      "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = { };
      "Mod+Ctrl+Shift+J".action.move-column-to-monitor-down = { };
      "Mod+Ctrl+Shift+K".action.move-column-to-monitor-up = { };
      "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = { };

      "Mod+Ctrl+Shift+Left".action.move-column-to-monitor-left = { };
      "Mod+Ctrl+Shift+Down".action.move-column-to-monitor-down = { };
      "Mod+Ctrl+Shift+Up".action.move-column-to-monitor-up = { };
      "Mod+Ctrl+Shift+Right".action.move-column-to-monitor-right = { };
    };

    # Workspace Navigation
    workspaces = {
      "Mod+U".action.focus-workspace-down = { };
      "Mod+I".action.focus-workspace-up = { };
      "Mod+Shift+U".action.move-column-to-workspace-down = { };
      "Mod+Shift+I".action.move-column-to-workspace-up = { };
      "Mod+Shift+Ctrl+U".action.move-workspace-down = { };
      "Mod+Shift+Ctrl+I".action.move-workspace-up = { };
    };

    # Mouse Wheel Navigation
    wheel = {
      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action.focus-column-or-monitor-right = { };
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action.focus-column-or-monitor-left = { };
      };
      "Mod+Shift+WheelScrollDown" = {
        cooldown-ms = 150;
        action.move-column-right-or-to-monitor-right = { };
      };
      "Mod+Shift+WheelScrollUp" = {
        cooldown-ms = 150;
        action.move-column-left-or-to-monitor-left = { };
      };
      "Mod+Ctrl+WheelScrollDown" = {
        cooldown-ms = 150;
        action.focus-window-or-workspace-down = { };
      };
      "Mod+Ctrl+WheelScrollUp" = {
        cooldown-ms = 150;
        action.focus-window-or-workspace-up = { };
      };
      "Mod+Ctrl+Shift+WheelScrollDown" = {
        cooldown-ms = 150;
        action.move-window-down-or-to-workspace-down = { };
      };
      "Mod+Ctrl+Shift+WheelScrollUp" = {
        cooldown-ms = 150;
        action.move-window-up-or-to-workspace-up = { };
      };
    };

    # Numbered Workspaces
    numbered = {
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;
    };

    sizing = {
      # Column Management
      "Mod+BracketLeft".action.consume-or-expel-window-left = { };
      "Mod+BracketRight".action.consume-or-expel-window-right = { };
      "Mod+Shift+BracketLeft".action.consume-window-into-column = { };
      "Mod+Shift+BracketRight".action.expel-window-from-column = { };

      # Sizing & Layout
      "Mod+R".action.switch-preset-column-width = { };
      "Mod+Ctrl+Shift+R".action.switch-preset-column-width-back = { };
      "Mod+Shift+R".action.switch-preset-window-height = { };
      "Mod+Alt+Shift+R".action.switch-preset-window-height-back = { };
      "Mod+Ctrl+R".action.reset-window-height = { };
      "Mod+Ctrl+F".action.expand-column-to-available-width = { };
      "Mod+C".action.center-column = { };
      "Mod+Ctrl+C".action.center-visible-columns = { };

      # Manual Sizing
      "Mod+Minus".action.set-column-width = "-5%";
      "Mod+Equal".action.set-column-width = "+5%";
      "Mod+Shift+Minus".action.set-window-height = "-5%";
      "Mod+Shift+Equal".action.set-window-height = "+5%";
    };

    # System Controls
    system = {
      "Mod+Escape" = {
        allow-inhibiting = false;
        action.toggle-keyboard-shortcuts-inhibit = { };
      };
      "Mod+Ctrl+Shift+P".action.power-off-monitors = { };
    };
  };

  rules = {
    # Global defaults
    defaults = [
      {
        geometry-corner-radius = cornerRadius 12.0;
        clip-to-geometry = true;
      }
    ];

    # Inactive windows
    inactive = [
      {
        matches = [ { is-active = false; } ];
        opacity = 0.85;
      }
    ];

    # WezTerm
    wezterm = [
      {
        matches = [ { app-id = "^org\\.wezfurlong\\.wezterm$"; } ];
        default-column-width.fixed = 741;
        draw-border-with-background = false;
        opacity = 0.9;
      }
      {
        matches = [
          {
            app-id = "^org\\.wezfurlong\\.wezterm$";
            is-active = false;
          }
        ];
        opacity = 0.85;
      }
    ];
  };
in
{
  inherit cornerRadius binds rules;

  # Everything, for the convenience modules. Attrsets are key-sorted, so the merge
  # order here does not affect the generated config.
  allBinds = builtins.foldl' (a: b: a // b) { } (builtins.attrValues binds);
  allRules = builtins.concatLists (builtins.attrValues rules);
}
