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
      indent-guides = {
        render = true;
      };
      lsp = {
        enable = true;
        auto-signature-help = true;
        display-messages = true;
        display-inlay-hints = true;
      };
    };
  };
}
