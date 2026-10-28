# Evaluation warnings for workarounds that wait on upstream, so none of them goes stale. Each
# list holds the consumer's entries; a rebuild prints a ⚑ warning when an entry needs a look:
# a package landed, a version moved past a patch or pin, or a pinned input moved. Insecure
# allowances and disabled features warn on every rebuild, as a standing reminder.
{ config, lib, pkgs, ... }:
let
  cfg = config.nixentials.watchlist;
  inherit (lib) mkOption types;

  entries =
    description: fields:
    mkOption {
      inherit description;
      default = [ ];
      type = types.listOf (types.submodule { options = fields; });
    };
  str = mkOption { type = types.str; };
  pkg = mkOption { type = types.package; };

  version =
    p:
    let
      eval = builtins.tryEval (p.version or null);
    in
    if eval.success then eval.value else null;
  keep = builtins.filter (w: w != null);
in
{
  options.nixentials.watchlist = {
    landing = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "bacon-ls" ];
      description = "Package attribute names not in nixpkgs yet. Warns once they are.";
    };
    drivers = entries "Driver regressions: warns once `pkg` moved past the `broken` version, to re-test." {
      pkg = pkg;
      broken = str;
      reason = str;
    };
    overlays = entries "Packages with a local overlay: warns once `pkg` moved past `patched`, to check whether the overlay can go." {
      pkg = pkg;
      patched = str;
      reason = str;
    };
    pinnedPackages = entries "Packages pinned with overrideAttrs: warns once nixpkgs moved past `pinned`, to bump the pin." {
      pkg = pkg;
      pinned = str;
      reason = str;
    };
    pinnedInputs = entries "Flake inputs pinned to a revision to dodge a regression: warns when the lock moved off it, and otherwise on every rebuild." {
      name = str;
      input = mkOption {
        type = types.attrs;
        description = "The flake input, such as `inputs.foo`.";
      };
      pinnedRev = str;
      reason = str;
    };
    insecure = entries "Insecure packages allowed on purpose. Warns on every rebuild." {
      name = mkOption {
        type = types.str;
        description = "`<pname>-<version>`, as in permittedInsecurePackages.";
      };
      reason = str;
    };
    disabled = entries "Features switched off until an upstream fix. Warns on every rebuild." {
      name = str;
      reason = str;
    };
  };

  config.warnings =
    keep (
      map (
        name:
        let
          v = version (pkgs.${name} or { });
        in
        if v != null then "⚑ ${name} is now in nixpkgs (${v})! Add it to your config." else null
      ) cfg.landing
    )
    ++ keep (
      map (
        e:
        let
          v = version e.pkg;
        in
        if v != null && v != e.broken then
          "⚑ ${e.pkg.pname} updated from ${e.broken} → ${v}. Re-test: ${e.reason}"
        else
          null
      ) cfg.drivers
    )
    ++ keep (
      map (
        e:
        if e.pkg.version != e.patched then
          "⚑ ${e.pkg.pname} updated from ${e.patched} → ${e.pkg.version}. Check if overlay can be removed: ${e.reason}"
        else
          null
      ) cfg.overlays
    )
    ++ keep (
      map (
        e:
        if e.pkg.version != e.pinned then
          "⚑ ${e.pkg.pname} moved ${e.pinned} → ${e.pkg.version}. Bump pin to match: ${e.reason}"
        else
          null
      ) cfg.pinnedPackages
    )
    ++ map (
      e:
      let
        locked = e.input.rev or null;
        short = lib.substring 0 7;
      in
      if locked != e.pinnedRev then
        "⚑ ${e.name} pin moved (expected ${short e.pinnedRev}, locked ${
          if locked == null then "unknown" else short locked
        }). Confirm fixed before unpinning: ${e.reason}"
      else
        "⚑ ${e.name} is pinned to ${short e.pinnedRev} — periodically re-test upstream: ${e.reason}"
    ) cfg.pinnedInputs
    ++ map (e: "⚑ ${e.name} is allowed via permittedInsecurePackages — ${e.reason}") cfg.insecure
    ++ map (e: "⚑ ${e.name} is disabled — ${e.reason}") cfg.disabled;
}
