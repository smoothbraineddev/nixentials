{ ... }:
{
  programs.helix.enable = true;
  programs.helix.defaultEditor = true;

  programs.helix.settings = {
    theme = "beans-dark";

    editor = {
      auto-completion = true;
      auto-format = true;
      auto-pairs = true;
      auto-save = true;
      # Colors the mode in the statusline with ui.statusline.{normal,insert,select}.
      color-modes = true;
      cursorline = true;
      gutters = [
        "diff"
        "diagnostics"
        "line-numbers"
        "spacer"
      ];
      insert-final-newline = true;
      line-number = "relative";
      mouse = true;
      text-width = 80;
      soft-wrap = {
        enable = true;
        max-indent-retain = 80;
      };
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      file-picker = {
        hidden = false;
      };
      # One per split. Helix's default elements plus the branch, without the file name, which sx
      # shows in scopeline. Helix pads the mode, selections and position with spaces, but not the
      # branch, the spinner or the diagnostics, hence the spacers. sx plugins put their own
      # elements at the front of the right side (session.hx its session name), so the first
      # spacer follows them. The spinner (LSP progress) sits next to the diagnostics.
      statusline = {
        left = [
          "mode"
          "version-control"
          "spacer"
          "read-only-indicator"
          "file-modification-indicator"
        ];
        center = [ ];
        right = [
          "spacer"
          "spinner"
          "spacer"
          "diagnostics"
          "selections"
          "register"
          "position"
          "file-encoding"
        ];
      };
      indent-guides = {
        render = true;
      };
      # Diagnostics down to hints in full, wrapped under the cursor line. sx also shows hints
      # after each line, cut off at the pane's edge.
      inline-diagnostics.cursor-line = "hint";
      lsp = {
        enable = true;
        auto-signature-help = true;
        display-messages = true;
        display-inlay-hints = true;
      };
    };
  };
}
