{ ... }:
{
  programs.zoxide.enableNushellIntegration = true;

  # Carapace: flag and argument completion for external commands
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;

    extraEnv = ''
      $env.PATH = ($env.PATH | prepend $"($env.HOME)/.local/bin")
      # Generate nix-your-shell config so nix-shell/nix develop drop into nushell
      mkdir ~/.cache/nix-your-shell
      nix-your-shell nu | save --force ~/.cache/nix-your-shell/init.nu
    '';

    extraConfig = ''
      source ~/.cache/nix-your-shell/init.nu

      # OSC 7: notify WezTerm of the current directory on every cd.
      # Required for Ctrl+Shift+N to open new windows in the correct cwd.
      $env.config.hooks.env_change.PWD = [{|_, dir|
        print -n $"\e]7;file://(^hostname)($dir)\a"
      }]

      # Alt+hjkl movement, works from insert and normal mode
      $env.config.keybindings = ($env.config.keybindings | append [
        { name: "alt_h" modifier: "alt" keycode: "char_h" mode: ["vi_insert", "vi_normal"] event: { edit: MoveLeft } }
        { name: "alt_l" modifier: "alt" keycode: "char_l" mode: ["vi_insert", "vi_normal"] event: { edit: MoveRight } }
        { name: "alt_k" modifier: "alt" keycode: "char_k" mode: ["vi_insert", "vi_normal"] event: { send: Up } }
        { name: "alt_j" modifier: "alt" keycode: "char_j" mode: ["vi_insert", "vi_normal"] event: { send: Down } }
      ])

      $env.config.show_banner = false
      $env.config.edit_mode = "vi"
      $env.config.cursor_shape.vi_insert = "underscore"
      $env.config.cursor_shape.vi_normal = "block"
      $env.config.completions.algorithm = "fuzzy"
      $env.config.completions.case_sensitive = false
      $env.config.history.file_format = "sqlite"
      $env.config.history.isolation = true
      $env.config.history.max_size = 100_000
      $env.config.table.trim = {
        methodology: truncating
        wrapping_try_keep_words: false
        truncating_suffix: "..."
      }

      # Shortcuts matching zsh aliases, defined as commands since nushell
      # aliases can't contain semicolons
      def c    [] { clear; fastfetch }

      # Cargo wrapper: add pedantic+nursery flags to clippy invocations
      def --wrapped cargo [...rest] {
        if (($rest | length) > 0) and (($rest | first) == "clippy") {
          ^cargo clippy ...($rest | skip 1) -- -W clippy::pedantic -W clippy::nursery
        } else {
          ^cargo ...$rest
        }
      }
    '';
  };
}
