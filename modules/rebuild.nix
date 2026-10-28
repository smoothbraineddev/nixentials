# `rebuild`, in zsh and nushell: `nh os switch --keep-going`, so one failure does not stop
# the other builds, with two additions.
#
# `-o NAME` (or `--override NAME`, repeatable) builds the flake input NAME from its checkout:
# it becomes --override-input NAME git+file://DIR, uncommitted changes to tracked files
# included (a new file needs `git add` first). DIR is ~/<reposDir>/NAME if that is a git
# checkout, otherwise zoxide's best match for NAME. `-o all` stands for every input in
# `inputs`. This hides nh's own -o (--out-link).
#
# With `builder` set, rebuild first checks that SSH reaches it. If it does, the build is
# offloaded (nixosModules.remote-builder) and only `localJobs` builds run here; otherwise
# everything builds here. `rebuild-local` always builds here.
{ config, lib, ... }:
let
  cfg = config.nixentials.rebuild;
  inherit (lib) mkOption types;
  all = lib.concatStringsSep " " cfg.inputs;
in
{
  options.nixentials.rebuild = {
    inputs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "nixentials" ];
      description = "Flake inputs that `-o all` builds from their checkouts.";
    };
    reposDir = mkOption {
      type = types.str;
      default = "Repos";
      description = "Directory of the checkouts, relative to the home directory.";
    };
    builder = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "desktop";
      description = "SSH host of a remote builder to probe before offloading, or null for none.";
    };
    localJobs = mkOption {
      type = types.int;
      default = 2;
      description = ''
        Builds that run here while offloading: the derivations marked preferLocalBuild
        (config files, wrappers), and anything else only while every remote slot is busy.
      '';
    };
  };

  config = {
    programs.zsh.initContent = ''
      # Sets $reply to the arguments with the -o/--override shorthand expanded.
      _rebuild_args() {
        reply=()
        local dir name
        while (( $# )); do
          case $1 in
            -o|--override)
              local names=("$2")
              [[ $2 == all ]] && names=(${all})
              for name in "''${names[@]}"; do
                dir=$HOME/${cfg.reposDir}/$name
                [[ -d $dir/.git ]] || dir=$(zoxide query -- "$name" 2>/dev/null)
                if [[ -z $dir ]]; then
                  print -u2 "rebuild: no checkout found for $name"
                  return 1
                fi
                reply+=(--override-input "$name" "git+file://$dir")
              done
              shift 2
              ;;
            *)
              reply+=("$1")
              shift
              ;;
          esac
        done
      }
    ''
    + (
      if cfg.builder == null then
        ''
          rebuild() {
            _rebuild_args "$@" || return
            nh os switch --keep-going "''${reply[@]}"
          }
        ''
      else
        ''
          rebuild() {
            _rebuild_args "$@" || return
            if ssh -o ConnectTimeout=3 -o BatchMode=yes ${cfg.builder} true 2>/dev/null; then
              print -P '%F{cyan}▸%f ${cfg.builder} reachable — offloading'
              nh os switch --keep-going --max-jobs ${toString cfg.localJobs} "''${reply[@]}"
            else
              print -P '%F{yellow}▸%f ${cfg.builder} unreachable — building local'
              nh os switch --keep-going "''${reply[@]}"
            fi
          }

          rebuild-local() {
            _rebuild_args "$@" || return
            nh os switch --keep-going --option builders "" "''${reply[@]}"
          }
        ''
    );

    programs.nushell.extraConfig = ''
      # The arguments with the -o/--override shorthand expanded.
      def rebuild-args [args: list] {
        mut out = []
        mut i = 0
        while $i < ($args | length) {
          let arg = $args | get $i
          if $arg in [-o --override] {
            let given = $args | get ($i + 1)
            let names = if $given == "all" { [${all}] } else { [$given] }
            for name in $names {
              let repo = $env.HOME | path join ${cfg.reposDir} $name
              let dir = if ($repo | path join .git | path exists) { $repo } else { ^zoxide query -- $name | str trim }
              $out = $out ++ [--override-input $name $"git+file://($dir)"]
            }
            $i += 2
          } else {
            $out = $out ++ [$arg]
            $i += 1
          }
        }
        $out
      }
    ''
    + (
      if cfg.builder == null then
        ''
          def --wrapped rebuild [...args] {
            ^nh os switch --keep-going ...(rebuild-args $args)
          }
        ''
      else
        ''
          def --wrapped rebuild [...args] {
            let args = rebuild-args $args
            let probe = (^ssh -o ConnectTimeout=3 -o BatchMode=yes ${cfg.builder} true | complete | get exit_code)
            if $probe == 0 {
              print "▸ ${cfg.builder} reachable — offloading"
              ^nh os switch --keep-going --max-jobs ${toString cfg.localJobs} ...$args
            } else {
              print "▸ ${cfg.builder} unreachable — building local"
              ^nh os switch --keep-going ...$args
            }
          }

          def --wrapped rebuild-local [...args] {
            ^nh os switch --keep-going --option builders "" ...(rebuild-args $args)
          }
        ''
    );
  };
}
