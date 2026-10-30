{ pkgs, ... }:
let
  # oh-my-zsh's plugins have no way to see their aliases from the shell. Bare, these commands
  # print the common ones by task. `<command> <fragment>` and tab completion cover all of them.
  # Their commands come from loading the plugin, so an alias it drops shows up as such here.
  helper =
    {
      name,
      plugin,
      width,
      layout,
    }:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [
        pkgs.gawk
        pkgs.git
        pkgs.gnused
        pkgs.zsh
      ];
      text = ''
        # Every alias of the plugin as name<TAB>command.
        aliases() {
          # shellcheck disable=SC2016
          zsh -fc 'unalias -m "*"; autoload -Uz is-at-least; source "$1" 2>/dev/null; alias' _ \
            ${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/${plugin}/${plugin}.plugin.zsh |
            sed -nE "s/^'?([^'=]+)'?=(.*)$/\1\t\2/p" |
            sed -E "s/\t'/\t/; s/'$//"
        }

        layout() {
          cat <<'LAYOUT'
        ${layout}
        LAYOUT
        }

        table() {
          awk -v width=${toString width} '
            NR == FNR { split($0, field, "\t"); command[field[1]] = field[2]; next }
            /^  / {
              name = $1
              note = $0
              sub(/^  [^ ]+ */, "", note)
              printf "  %-*s %s", width, name, (name in command) ? command[name] : "not in the plugin"
              print (note == "") ? "" : "  (" note ")"
              next
            }
            { print }
          ' <(aliases) <(layout | sed -E 's/^        //')
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
            aliases | awk -F '\t' -v width=${toString width} -v query="$*" '
              BEGIN { query = tolower(query) }
              index(tolower($0), query) { printf "  %-*s %s\n", width, $1, $2; found = 1 }
              END { exit !found }
            ' || { echo "${name}: nothing matches '$*'" >&2; exit 1; }
            ;;
        esac
      '';
    };

  gelp = helper {
    name = "gelp";
    plugin = "git";
    width = 7;
    layout = ''
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
    '';
  };

  scelp = helper {
    name = "scelp";
    plugin = "systemd";
    width = 16;
    layout = ''
      See what's going on
        sc-status
        sc-list-units
        sc-list-timers
        sc-cat
        sc-is-active
        sc-is-enabled

      Change a unit
        sc-start
        sc-stop
        sc-restart
        sc-reload
        sc-enable-now
        sc-disable-now
        sc-daemon-reload after editing unit files

      User units (scu- works for all of these)
        scu-status
        scu-restart
        scu-enable-now

      Power
        sc-suspend
        sc-hibernate
        sc-reboot
        sc-poweroff
    '';
  };
in
{
  home.packages = [
    gelp
    scelp
  ];

  programs.zsh.initContent = ''
    _plugin_help() {
      local -a rows
      rows=("''${(@f)$($words[1] --complete)}")
      _describe 'alias' rows
    }
    compdef _plugin_help gelp scelp
  '';
}
