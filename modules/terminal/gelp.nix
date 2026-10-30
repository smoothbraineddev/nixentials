{ pkgs, ... }:
let
  # The most common aliases of oh-my-zsh's git plugin, by task. The plugin has no way to see
  # them from the shell; the full list is in $ZSH/plugins/git/README.md.
  gelp = pkgs.writeShellApplication {
    name = "gelp";
    runtimeInputs = [ pkgs.gawk ];
    text = ''
      table() {
        cat <<'TABLE'
      See what's going on
        gst           status
        gss           status --short
        gd            diff
        gds           diff --staged
        glog          log --oneline --decorate --graph
        gsh           show

      Commit
        ga file       add
        gaa           add --all
        gcmsg "msg"   commit --message
        gcam "msg"    commit --all --message
        gcn!          commit --verbose --no-edit --amend

      Sync
        gl            pull
        gp            push
        gf            fetch
        gp -u remote branch   first push of a new branch

      Branches
        gb            branch
        gsw name      switch
        gswc name     switch --create
        gbd name      branch --delete
        gm name       merge
        grb name      rebase

      Undo and other
        grs file      restore (discards edits to the file, no undo)
        grh           reset (--hard also discards changes)
        gstp          stash pop
        gstl          stash list
      TABLE
      }

      case "''${1:-}" in
        "")
          table
          ;;
        --complete)
          # name:description pairs for zsh's _describe.
          table | awk '/^  / && !seen[$1]++ {
            line = substr($0, 3)
            match(line, /  +/)
            print $1 ":" substr(line, RSTART + RLENGTH)
          }'
          ;;
        *)
          table | awk -v query="$*" '
            BEGIN { query = tolower(query) }
            /^[^ ]/ { section = $0; shown = 0; next }
            /^  / && index(tolower($0), query) {
              if (!shown) { if (found) print ""; print section; shown = 1 }
              print
              found = 1
            }
            END { exit !found }
          ' || { echo "gelp: nothing matches '$*'" >&2; exit 1; }
          ;;
      esac
    '';
  };
in
{
  home.packages = [ gelp ];

  programs.zsh.initContent = ''
    _gelp() {
      local -a rows
      rows=("''${(@f)$(gelp --complete)}")
      _describe 'git alias' rows
    }
    compdef _gelp gelp
  '';
}
