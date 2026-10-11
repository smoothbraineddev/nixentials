{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  # niri has no IPC action for struts, so the toggle rewrites a writable file that the
  # generated config includes last. A later `struts` block replaces the earlier one
  # whole, so the other three sides repeat the configured values.
  struts = config.programs.niri.settings.layout.struts;
  wideLeft = -42;

  overrideFile = "${config.xdg.configHome}/niri/struts-override.kdl";
  wideStruts = pkgs.writeText "struts-override.kdl" ''
    layout {
        struts {
            left ${toString wideLeft}
            right ${toString struts.right}
            top ${toString struts.top}
            bottom ${toString struts.bottom}
        }
    }
  '';

  toggle = pkgs.writeShellScriptBin "niri-toggle-strut" ''
    if [ -s ${overrideFile} ]; then
      : > ${overrideFile}
    else
      cat ${wideStruts} > ${overrideFile}
    fi
  '';
in
{
  home.packages = [ toggle ];

  # Appended to the KDL niri-flake renders from programs.niri.settings, in its node format.
  # The path is absolute, so the build-time `niri validate` finds no file and skips the
  # include (optional=true needs niri 26.04). config.kdl stays niri-flake's, which leaves
  # the DMS niri module free to wrap it in its own includes.
  programs.niri.config = options.programs.niri.config.default ++ [
    {
      name = "include";
      arguments = [ overrideFile ];
      properties.optional = true;
      children = [ ];
    }
  ];

  # Create the override empty, so niri watches an existing file from the first toggle on.
  home.activation.niriStrutsOverride = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run touch ${overrideFile}
  '';
}
