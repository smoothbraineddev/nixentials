{ pkgs, ... }:
let
  # oh-my-zsh's git plugin has no way to see its aliases from the shell. Bare, gelp prints the
  # common ones by task. `gelp <fragment>` and tab completion cover all of them.
  gelp = pkgs.writeShellApplication {
    name = "gelp";
    runtimeInputs = [ pkgs.gawk ];
    text = ''
      # Every alias of the plugin as name<TAB>command, read from the plugin itself.
      aliases() {
        sed -nE "s/^[[:space:]]*alias '?([^'=]+)'?=(.*)$/\1\t\2/p" \
          ${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/git/git.plugin.zsh |
          sed -E "s/\t['\"]/\t/; s/['\"]$//" | awk -F '\t' '!seen[$1]++'
      }

      # Which aliases the short table shows, each with an optional note. Their commands come
      # from the plugin, so an alias it drops shows up as such here.
      layout() {
        cat <<'LAYOUT'
      See what's going on
        gst
        gss
        gd
        gds
        glog
        gsh

      Commit
        ga
        gaa
        gcmsg
        gcam
        gcn!

      Sync
        gl
        gp first push of a branch: gp -u <remote> <branch>
        gf

      Branches
        gb
        gsw
        gswc
        gbd
        gm
        grb

      Undo and other
        grs discards edits to the file, no undo
        grh --hard also discards changes
        gstp
        gstl
      LAYOUT
      }

      table() {
        awk '
          NR == FNR { split($0, field, "\t"); command[field[1]] = field[2]; next }
          /^  / {
            name = $1
            note = $0
            sub(/^  [^ ]+ */, "", note)
            printf "  %-7s %s", name, (name in command) ? command[name] : "not in the plugin"
            print (note == "") ? "" : "  (" note ")"
            next
          }
          { print }
        ' <(aliases) <(layout)
      }

      case "''${1:-}" in
        "")
          table
          ;;
        --complete)
          # name:description pairs for zsh's _describe.
          aliases | awk -F '\t' '{ print $1 ":" $2 }'
          ;;
        *)
          aliases | awk -F '\t' -v query="$*" '
            BEGIN { query = tolower(query) }
            index(tolower($0), query) { printf "  %-14s %s\n", $1, $2; found = 1 }
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
