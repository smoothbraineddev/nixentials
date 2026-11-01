{
  config,
  lib,
  pkgs,
  ...
}:
let
  # git pull, push, fetch and status. Bare, in a flake, they also cover the flake's git inputs that have
  # a checkout at ~/Repos/<name>, so a repo moves together with the repos it builds from. Those
  # follow nixentials.repoOrder, then the alphabet.
  command =
    name: text:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [
        pkgs.git
        pkgs.jq
      ];
      text = ''
        order=(${lib.escapeShellArgs config.nixentials.repoOrder})

        # Prints a repo's place in order, or the end of it for one that is not listed.
        rank() {
          local entry place=0
          for entry in "''${order[@]}"; do
            if [[ $entry == "$1" ]]; then break; fi
            place=$((place + 1))
          done
          echo "$place"
        }

        linked() {
          [[ $# -eq 0 ]] || return 0
          local top name
          top=$(git rev-parse --show-toplevel 2>/dev/null) || return 0
          [[ -f $top/flake.lock ]] || return 0
          jq -r '.nodes[].original | select(.type? == "git") | .url' "$top/flake.lock" |
            sed -E 's#.*/##; s#\.git$##' | sort -u | while read -r name; do
            if [[ -e $HOME/Repos/$name/.git ]]; then echo "$(rank "$name") $name"; fi
          done | sort -k1,1n -k2,2f | cut -d' ' -f2
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

  fetch = command "fetch" ''
    git fetch "$@" || result=$?
    for name in $(linked "$@"); do
      echo "$name:"
      git -C "$HOME/Repos/$name" fetch || result=1
    done
  '';

  # git's own -sb colors the local branch green and the remote red whatever their state. Bare,
  # this colors them by state instead. The branch is green when clean, yellow with only staged
  # changes, red with unstaged or untracked ones. Each remote, upstream first, is compared as of
  # the last fetch: green level, yellow ahead, red behind or diverged, gray without that branch.
  # Repos sort clean, then staged, then unstaged, so the ones needing work end next to the prompt.
  # Within those groups they follow nixentials.repoOrder, then the alphabet.
  status = command "status" ''
    paint() {
      if [[ -t 1 ]]; then printf '\033[%sm%s\033[0m' "$1" "$2"; else printf '%s' "$2"; fi
    }

    # Prints the sort key of a repo: its state (0 clean, 1 staged, 2 unstaged), its place in order.
    sort_key() {
      local changes state=0
      changes=$(git -C "$1" status --porcelain)
      if [[ -n $changes ]]; then
        state=1
        if grep -q '^.[^ ]' <<<"$changes"; then state=2; fi
      fi
      echo "$state $(rank "$2") $2 $1"
    }

    report() {
      local dir=$1 branch upstream remote counts ahead behind colors=(32 33 31)
      branch=$(git -C "$dir" symbolic-ref --short -q HEAD) || branch=$(git -C "$dir" rev-parse --short HEAD)
      printf '%s: ' "$2"
      paint "''${colors[$3]}" "$branch"
      upstream=$(git -C "$dir" config "branch.$branch.remote") || upstream=""
      for remote in $upstream $(git -C "$dir" remote | grep -vx "$upstream"); do
        printf ' '
        if ! git -C "$dir" rev-parse -q --verify "refs/remotes/$remote/$branch" >/dev/null; then
          paint 90 "$remote"
          continue
        fi
        counts=$(git -C "$dir" rev-list --left-right --count "refs/heads/$branch...refs/remotes/$remote/$branch")
        read -r ahead behind <<<"$counts"
        if [[ $ahead -eq 0 && $behind -eq 0 ]]; then
          paint 32 "$remote"
        elif [[ $behind -eq 0 ]]; then
          paint 33 "$remote [ahead $ahead]"
        elif [[ $ahead -eq 0 ]]; then
          paint 31 "$remote [behind $behind]"
        else
          paint 31 "$remote [ahead $ahead, behind $behind]"
        fi
      done
      echo
      git -C "$dir" status --short
    }

    if [[ $# -gt 0 ]]; then
      git status "$@" || result=$?
    else
      top=$(git rev-parse --show-toplevel)
      while read -r state _ name dir; do
        report "$dir" "$name" "$state"
      done < <({
        sort_key "$top" "$(basename "$top")"
        for name in $(linked "$@"); do
          sort_key "$HOME/Repos/$name" "$name"
        done
      } | sort -k1,1n -k2,2n -k3,3f)
    fi
  '';
in
{
  options.nixentials.repoOrder = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "nixentials" ];
    description = "Repos in the order bare `pull`, `push`, `fetch` and `status` handle them. Others follow alphabetically.";
  };

  config.home.packages = [
    pull
    push
    fetch
    status
  ];

  config.programs.zsh.initContent = ''
    compdef _git pull=git-pull push=git-push fetch=git-fetch status=git-status
  '';
}
