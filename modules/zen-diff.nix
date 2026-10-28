# zen-diff: how the live Zen prefs differ from the profile's user.js, such as one written by
# zen-profile, so changes made in the browser can go into the Nix config.
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "zen-diff";
      runtimeInputs = with pkgs; [ coreutils gawk gnused jq ];
      text = builtins.readFile ../scripts/zen-diff.sh;
    })
  ];
}
