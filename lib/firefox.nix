# Prefs and add-ons for any Firefox-based browser, shipped as data like ./zen.nix, which
# builds on this file. Tor Browser should not take the privacy prefs: its own defaults are
# what make its users look alike, and changing them sets one apart.
let
  render =
    fn: prefs:
    builtins.concatStringsSep "\n" (
      map (name: "${fn}(${builtins.toJSON name}, ${builtins.toJSON prefs.${name}});") (
        builtins.attrNames prefs
      )
    )
    + "\n";
in
{
  prefs.privacy = {
    "browser.contentblocking.category" = "custom";
    "privacy.fingerprintingProtection" = true;
    "privacy.donottrackheader.enabled" = true;
    "dom.security.https_only_mode" = true;

    # No speculative connections to links that were not clicked
    "network.dns.disablePrefetch" = true;
    "network.prefetch-next" = false;
    "network.http.speculative-parallel-limit" = 0;

    # DoH off, so DNS goes through the system resolver
    "network.trr.mode" = 5;
    "doh-rollout.disable-heuristics" = true;

    # Nothing sensitive is stored in the profile
    "signon.rememberSignons" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "privacy.clearOnShutdown_v2.formdata" = true;
  };

  # Add-on IDs from the AMO API, by a short name.
  addons = {
    bitwarden = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    darkreader = "addon@darkreader.org";
    noscript = "{73a6fe31-595d-460b-a920-fcc0f8843232}";
    ublock = "uBlock0@raymondhill.net";
    vimium = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
  };

  # `ids -> policies`: enterprise policies that install these add-ons from
  # addons.mozilla.org on first start and keep them updated. They belong to the package, so
  # the consumer passes them to wrapFirefox as `extraPolicies`. `normal_installed` lets the
  # user disable one, which NoScript needs on a site it breaks.
  extensionPolicies = ids: {
    ExtensionSettings = builtins.listToAttrs (
      map (id: {
        name = id;
        value = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
        };
      }) ids
    );
  };

  # `prefs -> string`: `user_pref(...)` lines for a profile's user.js.
  toUserJs = render "user_pref";

  # `prefs -> string`: `pref(...)` lines for the package's autoconfig file, as wrapFirefox's
  # `extraPrefs` and tor-browser's `extraPrefs` take them. They are set on every start, and
  # the user can still change them for the session.
  toAutoconfig = render "pref";
}
