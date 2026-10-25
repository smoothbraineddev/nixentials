{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.programs.niri.strutToggle;
  perOutput = cfg.wideOutputs != { };

  # niri has no IPC action for struts, so the toggle rewrites a writable file that the
  # generated config includes. A `struts` block replaces any earlier one whole, so the
  # sides the wide state leaves out repeat the configured values.
  struts = config.programs.niri.settings.layout.struts;
  strutsLines =
    indent: wide:
    [ "${indent}struts {" ]
    ++ map (side: "${indent}    ${side} ${toString (wide.${side} or struts.${side})}") [
      "left"
      "right"
      "top"
      "bottom"
    ]
    ++ [ "${indent}}" ];

  # niri uses the first `output` section that matches and does not merge a second one, so
  # a per-output wide state repeats the whole rendered section with a layout added, and
  # the file is included before the generated config.
  renderedLines = lib.splitString "\n" config.programs.niri.finalConfig;
  outputBody =
    name:
    let
      start = lib.lists.findFirstIndex (l: l == "output ${builtins.toJSON name} {") null renderedLines;
      rest = lib.drop (start + 1) renderedLines;
    in
    if start == null then [ ] else lib.take (lib.lists.findFirstIndex (l: l == "}") 0 rest) rest;

  overrideFile = "${config.xdg.configHome}/niri/struts-override.kdl";

  # One file per output, so the toggle can write any subset of the wide outputs.
  outputKdl =
    name: wide:
    pkgs.writeText "struts-output.kdl" (
      lib.concatLines (
        [ "output ${builtins.toJSON name} {" ]
        ++ outputBody name
        ++ [ "    layout {" ]
        ++ strutsLines "        " wide
        ++ [
          "    }"
          "}"
        ]
      )
    );
  caseArms =
    action:
    lib.concatStrings (
      lib.mapAttrsToList (
        name: wide: "    ${lib.escapeShellArg name}) ${action (outputKdl name wide)} ;;\n"
      ) cfg.wideOutputs
    );
  wideKdl = pkgs.writeText "struts-override.kdl" (
    lib.concatLines ([ "layout {" ] ++ strutsLines "    " cfg.wideStruts ++ [ "}" ])
  );

  # Per output, the toggle flips only the focused output. The override file is the state:
  # an output is wide while the file has a section for it.
  toggle = pkgs.writeShellScriptBin "niri-toggle-strut" (
    if perOutput then
      ''
        # niri matches an output section by connector or by "make model serial", with
        # "Unknown" for a missing serial.
        key=
        while IFS= read -r id; do
          case "$id" in
        ${caseArms (_: "key=$id; break")}  esac
        done < <(niri msg --json focused-output |
          ${lib.getExe pkgs.jq} -r '.name, "\(.make) \(.model) \(.serial // "Unknown")"')
        [ -n "$key" ] || exit 0

        wide=()
        found=
        while IFS= read -r name; do
          if [ "$name" = "$key" ]; then found=1; else wide+=("$name"); fi
        done < <(sed -n 's/^output "\(.*\)" {$/\1/p' ${overrideFile})
        [ -n "$found" ] || wide+=("$key")

        for name in "''${wide[@]}"; do
          case "$name" in
        ${caseArms (kdl: "cat ${kdl}")}  esac
        done > ${overrideFile}
      ''
    else
      ''
        if [ -s ${overrideFile} ]; then
          : > ${overrideFile}
        else
          cat ${wideKdl} > ${overrideFile}
        fi
      ''
  );

  # In niri-flake's node format. The path is absolute, so the build-time `niri validate`
  # finds no file and skips the include (optional=true needs niri 26.04).
  includeNode = {
    name = "include";
    arguments = [ overrideFile ];
    properties.optional = true;
    children = [ ];
  };

  sides = lib.types.attrsOf lib.types.int;
in
{
  options.programs.niri.strutToggle = {
    wideStruts = lib.mkOption {
      type = sides;
      default = {
        left = -38;
      };
      description = ''
        Struts for the wide state, on every output. Sides left out keep
        programs.niri.settings.layout.struts. A DMS island bar in notch mode has no outer
        gap and reserves the larger of islandReserveThickness (40px by default) and its
        pill, 36px in dms-laptop. -38 leaves 2px of the 40, so a window sits one gap plus
        2px from the screen edge.
      '';
    };
    wideOutputs = lib.mkOption {
      type = lib.types.attrsOf sides;
      default = { };
      example = {
        "DP-3".left = -38;
      };
      description = ''
        Struts for the wide state per output, keyed by the name the output has in
        programs.niri.settings.outputs. When set, it replaces wideStruts, so outputs
        without a bar stay as they are, and niri-toggle-strut flips only the focused output.
      '';
    };
  };

  config = {
    home.packages = [ toggle ];

    # config.kdl stays niri-flake's, which leaves the DMS niri module free to wrap it in
    # its own includes.
    programs.niri.config =
      if perOutput then
        [ includeNode ] ++ options.programs.niri.config.default
      else
        options.programs.niri.config.default ++ [ includeNode ];

    # Create the override empty, so niri watches an existing file from the first toggle on.
    home.activation.niriStrutsOverride = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run touch ${overrideFile}
    '';
  };
}
