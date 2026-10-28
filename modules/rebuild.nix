# `rebuild`, in zsh and nushell: `nh os switch --keep-going`, so one failure does not stop
# the other builds, with two additions.
#
# `-o NAME` (or `--override NAME`, repeatable) builds the flake input NAME from its checkout:
# it becomes --override-input NAME git+file://DIR, uncommitted changes to tracked files
# included (a new file needs `git add` first). DIR is ~/<reposDir>/NAME if that is a git
# checkout, otherwise zoxide's best match for NAME. `-o all` stands for every input in
# `inputs`. This hides nh's own -o (--out-link).
#
# With `builder` set, rebuild first checks that its SSH server answers (ssh-keyscan, which
# needs no login). If it does, the build is
# offloaded (nixosModules.remote-builder) and only `localJobs` builds run here; otherwise
# everything builds here. `rebuild-local` always builds here.
#
# Also: `rebuild-boot` and `rebuild-test` (nh os boot / test, with -o too), `rollback`,
# `generations` to list the system generations, and `gen-diff OLD NEW` to compare two.
{ config, lib, ... }:
let
  cfg = config.nixentials.rebuild;
  inherit (lib) mkOption types;
  all = lib.concatStringsSep " " cfg.inputs;
  aliases = {
    generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | less +G";
    rollback = "nh os rollback";
  };
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
      description = "Host of a remote builder whose SSH server is probed before offloading, or null for none.";
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
    programs.zsh.shellAliases = aliases;
    programs.nushell.shellAliases = aliases;

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

      rebuild-boot() {
        _rebuild_args "$@" || return
        nh os boot --keep-going "''${reply[@]}"
      }

      rebuild-test() {
        _rebuild_args "$@" || return
        nh os test --keep-going "''${reply[@]}"
      }

      # Compare two system generations: gen-diff 141 142
      gen-diff() {
        if [[ $# -ne 2 ]]; then
          echo "Usage: gen-diff <old-gen> <new-gen>"
          return 1
        fi
        nix store diff-closures /nix/var/nix/profiles/system-{$1,$2}-link
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
            if [[ -n $(ssh-keyscan -T 3 ${cfg.builder} 2>/dev/null) ]]; then
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

      def --wrapped rebuild-boot [...args] {
        ^nh os boot --keep-going ...(rebuild-args $args)
      }

      def --wrapped rebuild-test [...args] {
        ^nh os test --keep-going ...(rebuild-args $args)
      }

      # Compare two system generations: gen-diff 141 142
      def gen-diff [old: int, new: int] {
        nix store diff-closures $"/nix/var/nix/profiles/system-($old)-link" $"/nix/var/nix/profiles/system-($new)-link"
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
            let probe = (^ssh-keyscan -T 3 ${cfg.builder} | complete | get stdout | str trim)
            if $probe != "" {
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
