{ ... }:
{
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = false; # Our PATH wrapper handles nushell; broot's integration may shadow it

    settings = {
      verbs = [
        {
          invocation = "create {new_file}";
          execution = "edit {directory}/{new_file}";
          leave_broot = false;
        }
        {
          invocation = "edit";
          key = "F2";
          shortcut = "e";
          # `edit` (helix.nix) spawns into the running wezterm and swallows its own
          # output. broot splits `execution` on whitespace with no shell, so a
          # redirect can only live inside the script, not here.
          execution = "edit --cwd {root} {file}";
          apply_to = "file";
          leave_broot = false;
        }
        {
          key = "enter";
          execution = "edit --cwd {root} {file}";
          apply_to = "file";
          leave_broot = false;
        }
        { key = "alt-j"; internal = "line_down"; }
        { key = "alt-k"; internal = "line_up"; }
        { key = "alt-h"; internal = "back"; }
        { key = "alt-l"; internal = "open_stay"; }
      ];
    };
  };
}
