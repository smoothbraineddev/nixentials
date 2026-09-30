{
  config,
  lib,
  pkgs,
  ...
}:
let
  zen = import ../lib/zen.nix;

  userJs = pkgs.writeText "user.js" (zen.toUserJs zen.allPrefs);

  userChromeCss = pkgs.writeText "userChrome.css" ''
    @import url("file://${config.xdg.configHome}/zen/customTheme.css");
  '';

  themeStore = pkgs.fetchFromGitHub {
    owner = "zen-browser";
    repo = "theme-store";
    rev = "7173dba5d060417fd65764b706856ae609496e31";
    hash = "sha256-Vq0AboLzase+tTZ1Erf2cKpF55cm3eHNuXmmQuOknvw=";
  };

  # What Zen keeps per profile for mods: zen-themes.json lists them, and
  # chrome/zen-themes/<id>/ holds their files. An entry of zen-themes.json is the
  # store's theme.json plus the enabled flag.
  mods = pkgs.runCommand "zen-mods" { nativeBuildInputs = [ pkgs.jq ]; } ''
    mkdir -p $out/zen-themes
    for id in ${toString (builtins.attrNames zen.mods)}; do
      src=${themeStore}/themes/$id
      mkdir $out/zen-themes/$id
      cp $src/chrome.css $src/readme.md $out/zen-themes/$id/
      if [ -f $src/preferences.json ]; then
        cp $src/preferences.json $out/zen-themes/$id/
      fi
      jq '. + { enabled: true }' $src/theme.json
    done | jq -s 'map({ key: .id, value: . }) | from_entries' > $out/zen-themes.json
  '';
in
{
  imports = [ ./zen-theme.nix ];

  # Zen creates the profile on first launch and records its directory in profiles.ini,
  # so home.file cannot name the target. Until that file exists this does nothing:
  # start Zen once, then activate again.
  home.activation.zen-profile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    zenDir="${config.xdg.configHome}/zen"
    zenProfile=""
    if [ -f "$zenDir/profiles.ini" ]; then
      # Prefer the [Install*] Default= path, fall back to the [Profile*] with Default=1
      zenProfile=$(${pkgs.gawk}/bin/awk -F= '
        /^\[Install/   { in_install=1; next }
        /^\[/          { if (in_install && install_path) exit; in_install=0 }
        in_install && $1=="Default" { install_path=$2 }
        /^\[Profile/   { in_profile=1; path=""; is_default=0; next }
        /^\[/          { if (in_profile && is_default && path) { fallback=path }; in_profile=0 }
        in_profile && $1=="Path"    { path=$2 }
        in_profile && $1=="Default" && $2=="1" { is_default=1 }
        END {
          if (install_path) print install_path
          else if (fallback) print fallback
          else if (is_default && path) print path
        }
      ' "$zenDir/profiles.ini" 2>/dev/null || true)
    fi

    if [ -n "$zenProfile" ]; then
      run mkdir -p "$zenDir/$zenProfile/chrome"
      run ln -sf ${userJs} "$zenDir/$zenProfile/user.js"
      run ln -sf ${userChromeCss} "$zenDir/$zenProfile/chrome/userChrome.css"

      # Copied, not linked: Zen writes to zen-themes.json, where the enabled flag of
      # each mod lives, and the store is read-only. Every activation resets both.
      run install -m 644 ${mods}/zen-themes.json "$zenDir/$zenProfile/zen-themes.json"
      run rm -rf "$zenDir/$zenProfile/chrome/zen-themes"
      run cp -r --no-preserve=mode ${mods}/zen-themes "$zenDir/$zenProfile/chrome/zen-themes"
    fi
  '';
}
