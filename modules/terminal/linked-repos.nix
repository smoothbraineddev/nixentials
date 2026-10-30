{ pkgs, ... }:
let
  # git pull and git push. Bare, in a flake, they also cover the flake's git inputs that have
  # a checkout at ~/Repos/<name>, so a repo moves together with the repos it builds from.
  command =
    name: text:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [
        pkgs.git
        pkgs.jq
      ];
      text = ''
        linked() {
          [[ $# -eq 0 ]] || return 0
          local top name
          top=$(git rev-parse --show-toplevel 2>/dev/null) || return 0
          [[ -f $top/flake.lock ]] || return 0
          jq -r '.nodes[].original | select(.type? == "git") | .url' "$top/flake.lock" |
            sed -E 's#.*/##; s#\.git$##' | sort -u | while read -r name; do
            if [[ -e $HOME/Repos/$name/.git ]]; then echo "$name"; fi
          done
        }

        result=0
        ${text}
        exit "$result"
      '';
    };

  pull = command "pull" ''
    git pull "$@" || result=$?
    for name in $(linked "$@"); do
      echo "$name:"
      git -C "$HOME/Repos/$name" pull --ff-only || result=1
    done
  '';

  # Inputs go first, so the lock file here never pins a revision the remote lacks.
  push = command "push" ''
    for name in $(linked "$@"); do
      echo "$name:"
      git -C "$HOME/Repos/$name" push || result=1
    done
    git push "$@" || result=$?
  '';
in
{
  home.packages = [
    pull
    push
  ];

  programs.zsh.initContent = ''
    compdef _git pull=git-pull push=git-push
  '';
}
