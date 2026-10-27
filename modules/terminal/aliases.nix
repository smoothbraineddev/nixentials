{ ... }:
let
  shared = {
    q = "exit";

    # Tools
    cat = "bat";
    zed = "zeditor ./";

    # Misc
    m = "cmatrix -abC magenta";
  };
in
{
  programs.zsh.shellAliases = shared // {
    # Clear, then fastfetch with an empty line above and below, so the logo does not touch
    # the prompt. ./zsh.nix runs it at startup.
    c = "clear; (( $+commands[fastfetch] )) && { echo; fastfetch; echo; }";
    x = "extract";

    ls = "eza";
    l = "eza -lh";
    lT = "eza -lhTL";
    la = "eza -lah";
    laT = "eza -lahTL";
  };

  programs.nushell.shellAliases = shared // {
    l = "ls -l";
    la = "ls -la";
  };
}
