{ pkgs, ... }:
{
  # zoxide's doctor check runs inside the `cd` function and reads $_ZO_DOCTOR
  # at call time. Set it in .zshenv (via sessionVariables) so it applies to
  # non-interactive shells too, since those don't fully source .zshrc.
  home.sessionVariables._ZO_DOCTOR = "0";

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height=40%"
      "--border=rounded"
      "--layout=reverse"
      "--info=inline"
    ];
    fileWidget.command = "fd --type f --hidden --follow --exclude .git";
    changeDirWidget.command = "fd --type d --hidden --follow --exclude .git";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "colored-man-pages"
        "extract"
        "git"
        "rust"
      ];
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initContent = ''
      bindkey -v

      cargo() {
        if [[ "$1" == "clippy" ]]; then
          command cargo clippy "''${@:2}" -- -W clippy::pedantic -W clippy::nursery
        else
          command cargo "$@"
        fi
      }

      zstyle ':fzf-tab:*' fzf-command fzf
      zstyle ':fzf-tab:*' switch-group ',' '.'
      zstyle ':fzf-tab:*' query-string disabled
      zstyle ':fzf-tab:complete:*' fzf-preview 'bat --color=always --style=numbers $realpath 2>/dev/null || ls --color=always $realpath 2>/dev/null'

      _starship_transient() {
        local _rc=$?
        local _p="$PROMPT" _rp="$RPROMPT"
        if [[ $_rc -eq 0 ]]; then
          PROMPT=$'%B%F{green}❯%f%b '
        else
          PROMPT=$'%B%F{red}❯%f%b '
        fi
        RPROMPT=""
        zle reset-prompt
        PROMPT="$_p" RPROMPT="$_rp"
        zle .accept-line
      }
      zle -N accept-line _starship_transient

      # Cursor shape per vi mode: block in normal, underline in insert
      zle-line-init() { echo -ne '\e[4 q'; }
      zle -N zle-line-init
      zle-keymap-select() {
        case $KEYMAP in
          vicmd)      echo -ne '\e[2 q' ;;  # block (normal mode)
          viins|main) echo -ne '\e[4 q' ;;  # underline (insert mode)
        esac
        zle reset-prompt
      }
      zle -N zle-keymap-select

      ZLE_RPROMPT_INDENT=0

      # Startup
      fastfetch
    '';
  };
}
