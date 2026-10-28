# dms-diff: the DMS settings changed in the running shell since the last rebuild, which DMS
# loses on restart, as Nix lines to paste, each under the .nix files that set the key. It
# searches nixentials' dms-settings and `nixentials.dmsDiff.dirs`.
{ config, lib, pkgs, ... }:
let
  settings = ./dms-settings;
in
{
  options.nixentials.dmsDiff.dirs = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "$HOME/.nix/home/modules/dms" ];
    description = "Directories with the consumer's DMS .nix files, searched for the keys that changed. $HOME expands at run time.";
  };

  config.home.packages = [
    (pkgs.writeShellApplication {
      name = "dms-diff";
      runtimeInputs = with pkgs; [ coreutils diffutils gnugrep jq ];
      text = ''
        NIXENTIALS_SETTINGS=${settings}
        DMS_DIFF_DIRS="${lib.concatStringsSep "\n" ([ "${settings}" ] ++ config.nixentials.dmsDiff.dirs)}"
      '' + builtins.readFile ../scripts/dms-diff.sh;
    })
  ];
}
