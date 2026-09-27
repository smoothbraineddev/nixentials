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
    c = "clear; fastfetch;";
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
