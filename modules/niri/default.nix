# Niri, minus everything role-specific.
#
# No binds, no window-rules, no outputs. Binds and rules ship as data from
# ../../lib/niri.nix, and as the niri-binds / niri-rules convenience modules.
# Outputs are host-specific by nature and never belong here.
{ ... }:
{
  imports = [
    ./animations.nix
    ./input.nix
    ./layout.nix
    ./misc.nix
    ./startup.nix
    ./theme.nix
  ];
}
