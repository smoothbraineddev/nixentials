{ lib, pkgs, ... }:
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

  # nix develop, nix shell and nix-shell start zsh instead of bash, with the prompt, aliases
  # and the rest of this config.
  programs.nix-your-shell = {
    enable = true;
    enableZshIntegration = true;
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
        "systemd"
      ];
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initContent = lib.mkMerge [
      ''
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
      ''

      # Dev shells for WezTerm's Ctrl+Shift+N (wezterm/config.nix). preexec exports a command
      # that enters one (nix develop, nix shell, nix-shell) with the directory it ran in, so
      # the zsh inside inherits both, and every prompt reports them to WezTerm as the
      # user vars devshell and devshell_dir. Back at the outer prompt, precmd restores and
      # reports the outer values. Ctrl+Shift+N reruns the command there and passes the new
      # window's directory in DEVSHELL_CD. Not over SSH, where the directory is remote.
      ''
        if [[ -n $DEVSHELL_CD ]]; then
          builtin cd -- "$DEVSHELL_CD"
          unset DEVSHELL_CD
        fi

        _devshell_preexec() {
          [[ $3 == (nix (develop|shell)|nix-shell)(| *) ]] || return
          _devshell_saved=("$DEVSHELL_CMD" "$DEVSHELL_DIR")
          export DEVSHELL_CMD=$3 DEVSHELL_DIR=$PWD
        }
        _devshell_precmd() {
          [[ -z $SSH_CONNECTION ]] || return
          if (( ''${+_devshell_saved} )); then
            DEVSHELL_CMD=$_devshell_saved[1] DEVSHELL_DIR=$_devshell_saved[2]
            unset _devshell_saved
            [[ -n $DEVSHELL_CMD ]] || unset DEVSHELL_CMD DEVSHELL_DIR
          fi
          # Every prompt, since a dev shell in a vmshell guest reports to the same pane.
          if [[ $DEVSHELL_CMD$'\0'$DEVSHELL_DIR != "$_devshell_last" ]]; then
            _devshell_last=$DEVSHELL_CMD$'\0'$DEVSHELL_DIR
            _devshell_osc=$(printf '\e]1337;SetUserVar=devshell=%s\a\e]1337;SetUserVar=devshell_dir=%s\a' \
              "''${DEVSHELL_CMD:+$(print -rn -- $DEVSHELL_CMD | base64 -w0)}" \
              "''${DEVSHELL_DIR:+$(print -rn -- $DEVSHELL_DIR | base64 -w0)}")
          fi
          print -rn -- $_devshell_osc
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook preexec _devshell_preexec
        add-zsh-hook precmd _devshell_precmd
      ''

      # Startup, as the last lines of .zshrc, after the aliases, so it can run the c alias. Not in
      # dev shells or over SSH, where only the prompt changes. An if, because c expands to
      # several commands and `&& c` would only guard the first.
      (lib.mkOrder 2000 "if [[ -z $IN_NIX_SHELL && -z $SSH_CONNECTION ]]; then c; fi")
    ];
  };
}
