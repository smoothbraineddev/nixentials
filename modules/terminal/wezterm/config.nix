{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.meslo-lgs-nf ];

  programs.wezterm = {
    enable = true;
    extraConfig = lib.mkMerge [
      (lib.mkOrder 100 ''
        local config = wezterm.config_builder()

        config.default_prog = { 'zsh' }

        config.enable_wayland = true

        -- Window
        local base_pad = 5
        config.window_decorations = "NONE"
        config.window_padding = { left = base_pad, right = base_pad, top = base_pad, bottom = base_pad }
        config.window_background_opacity = 1.0
        config.enable_tab_bar = false
        config.window_close_confirmation = 'NeverPrompt'
        config.adjust_window_size_when_changing_font_size = false

        -- Font
        config.font = wezterm.font('MesloLGS NF')
        config.font_size = 9.0

        -- Scrollback
        config.scrollback_lines = 3023

        -- Cursor
        config.default_cursor_style = 'BlinkingBlock'
        config.cursor_blink_rate = 500
        config.cursor_blink_ease_in = 'Constant'
        config.cursor_blink_ease_out = 'Constant'

        -- Mouse
        config.hide_mouse_cursor_when_typing = true

        -- Bell
        config.audible_bell = 'Disabled'

        -- Match alacritty: bold text does NOT substitute bright color variants
        config.bold_brightens_ansi_colors = false

        -- Anchor content to the bottom: under tiling WMs the window rarely fits
        -- a whole number of cells, so the sub-cell leftover gets pushed into the
        -- TOP padding instead of dangling as a half-row at the bottom. 
        local function adjust_padding(window, pane)
          local overrides = window:get_config_overrides() or {}
          local window_dims = window:get_dimensions()
          local pane_dims = pane:get_dimensions()

          if window_dims.is_full_screen then
            overrides.window_padding = nil
            window:set_config_overrides(overrides)
            return
          end

          -- Derive cell_height from the pane's pixels-to-rows ratio: both
          -- numerator and denominator are briefly stale during a resize, but
          -- their quotient is invariant.
          local cell_height = pane_dims.pixel_height / pane_dims.viewport_rows
          local available = window_dims.pixel_height - base_pad
          local top_padding = available - math.floor(available / cell_height) * cell_height

          if overrides.window_padding and overrides.window_padding.top == top_padding then
            return
          end

          overrides.window_padding =
            { left = base_pad, right = base_pad, top = top_padding, bottom = base_pad }
          window:set_config_overrides(overrides)
        end

        wezterm.on('window-resized', adjust_padding)
        wezterm.on('window-config-reloaded', adjust_padding)

        -- Keybindings
        config.keys = {
          { key = 'Return', mods = 'SHIFT', action = wezterm.action.SendString '\n' },

          -- Wayland clipboard offer is only delivered to the focused surface, so WezTerm
          -- window B never receives the offer from window A. Bypass PasteFrom entirely.
          -- Fix pending: https://github.com/wezterm/wezterm/pull/7034
          { key = 'V', mods = 'CTRL|SHIFT', action = wezterm.action_callback(function(_, pane)
              local success, stdout = wezterm.run_child_process({ 'wl-paste', '--no-newline' })
              if success then pane:send_text(stdout) end
            end) },

          -- New WezTerm window in the current pane's cwd.
          { key = 'N', mods = 'CTRL|SHIFT', action = wezterm.action_callback(function(window, pane)
              local url = pane:get_current_working_dir()
              window:perform_action(wezterm.action.SpawnCommandInNewWindow {
                cwd = url and url.file_path or nil,
              }, pane)
            end) },
        }
      '')
      (lib.mkOrder 9999 ''
        return config
      '')
    ];
  };
}
