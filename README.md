# nixentials

Shared look, terminal and session config for NixOS with home-manager, factored out so a
workstation, a headless server and an install image can import the same thing.

nix + essentials.

## What this holds

`colors.nix` and the theming, plus the behaviour config that does not vary by role.
The boundary is a file-level one: `theme.nix` holds colour and visual styling, its
siblings hold behaviour.

## What never goes in here

This repo is public. It carries no secrets, no host specifics, and no service config.

- SSH public keys, `users.users.*` blocks
- `ssh.nix`, whose matchBlocks name internal hosts and leak network topology
- `outputs.nix`, `hardware-configuration.nix`, disk layouts
- Substituters pointing at private infrastructure

## Outputs

| Output | Contents |
|---|---|
| `lib.colors` | The five palettes as data (`smoothbrained`, `beans`, `gruvbox`, `dank16`, `md3`), plus the `hexToRgb` and `stripHash` helpers, for apps wanting decimal or unprefixed hex |
| `lib.niri.cornerRadius` | `r -> { top-left; top-right; bottom-right; bottom-left; }`. All four corners are required by `geometry-corner-radius` |
| `lib.niri.binds` | Bind groups as data, keyed by section |
| `lib.niri.rules` | Window-rule groups as data |
| `lib.zen.prefs` | The Zen prefs for `user.js` as data, in the groups `core`, `privacy`, `layout` and `mods` |
| `lib.zen.allPrefs` | Every group of `lib.zen.prefs`, merged |
| `lib.zen.mods` | The Zen mods as `id -> name`, where the id is the directory under `themes/` in `github:zen-browser/theme-store` |
| `lib.zen.policies` | Enterprise policies for the Zen package: installs uBlock Origin, Bitwarden, Dark Reader and NoScript |
| `lib.zen.toUserJs` | `prefs -> string`, renders an attrset as `user_pref(...)` lines |
| `homeModules.terminal` | wezterm, starship, fastfetch, zsh, nushell, aliases, broot, yazi |
| `homeModules.editor` | helix settings, languages, theme |
| `homeModules.niri-core` | animations, input, layout, misc, startup, theme, and the strut toggle (see below). No binds, rules or outputs |
| `homeModules.niri-binds` | Every `lib.niri.binds` group, applied |
| `homeModules.niri-rules` | Every `lib.niri.rules` group, applied |
| `homeModules.toolkit` | gtk, qt |
| `homeModules.dms-theme` | The DMS colour mapping only |
| `homeModules.dms-settings` | The DMS settings of the laptop config: theme, launcher, notifications, lock screen, cursor, dock, control center, dash, and the bar on the left edge in island mode, reserving no space and not scrolling niri columns. Also the feature toggles and clipboard settings. Plugins, `enable` and `systemd` stay with the consumer. Needs `inputs.dms.homeModules.dank-material-shell` |
| `homeModules.dms-island` | Patches the DMS package: a 6px gap between the island's media, clock and weather, and the island clock at 14px, weight 900. Needs `inputs.dms.homeModules.dank-material-shell` |
| `homeModules.zen-theme` | The Zen CSS only |
| `homeModules.zen-profile` | `zen-theme`, plus an activation step for the default Zen profile: a `user.js` from `lib.zen.allPrefs`, a `userChrome.css` loading the theme, and the mods in `lib.zen.mods` |
| `nixosModules.session` | niri, xwayland, portals, greetd + tuigreet, gnome-keyring, session env vars |

## Using it

Follow your own nixpkgs, so only one lands in your closure:

```nix
inputs.nixentials = {
  url = "git+https://gitlab.com/smoothbraineddev/nixentials.git";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Every `homeModules` output is a plain module, evaluated with your `pkgs`. This flake's
own `nixpkgs` input exists only so it can check itself.

Import the convenience modules if you agree with the defaults:

```nix
home-manager.users.<you>.imports = [
  inputs.nixentials.homeModules.terminal
  inputs.nixentials.homeModules.editor
  inputs.nixentials.homeModules.niri-core
  inputs.nixentials.homeModules.niri-binds
  inputs.nixentials.homeModules.niri-rules
];
```

Or compose from the data when you want to change or drop something, which needs no
`mkForce` because `//` is right-biased:

```nix
programs.niri.settings.binds =
  with inputs.nixentials.lib.niri.binds;
  focus // movement // columns // workspaces // numbered // sizing // windows // lock
  // { "Mod+Return".action.spawn = "foot"; }   # wins over ours
  // myLaunchers;

programs.niri.settings.window-rules =
  inputs.nixentials.lib.niri.rules.defaults
  ++ inputs.nixentials.lib.niri.rules.inactive
  ++ myAppRules;
```

`mkForce` is only needed if you import `niri-binds` *and* want to change one of its
binds. Compose from `lib.niri.binds` instead.

## Strut toggle

niri has no IPC action for struts. `niri-core` therefore appends one `include` line to the
config niri-flake generates. It points at `~/.config/niri/struts-override.kdl` by absolute
path and sets `optional=true`, which needs niri 26.04.

`niri-toggle-strut` switches that file between empty and the wide state. By default that
is a `struts` block with `left -42`. That cancels the 42px exclusive zone of the
`dms-settings` bar, so a window sits one gap from the screen edge. Sides the wide state leaves
out repeat `programs.niri.settings.layout.struts`, because a later `struts` block
replaces the earlier one whole. niri reloads the file on change. The `struts` bind group
puts the toggle on `Mod+T`.

`programs.niri.strutToggle.wideStruts` sets the wide state for every output. For bars on
different edges, set `programs.niri.strutToggle.wideOutputs` instead, keyed by the
output names in `programs.niri.settings.outputs`:

```nix
programs.niri.strutToggle.wideOutputs = {
  "DP-3".left = -42;
  "DP-2".right = -42;
};
```

niri uses the first `output` section that matches and does not merge a later one. In
this mode the file therefore repeats each named output's rendered section with a
`layout` added, and the include moves to the top of the generated config.

The file is writable and outside the store, so a value edited there applies at once and
lasts until the next toggle. To keep a value, set it in `programs.niri.strutToggle`.

## DMS niri includes

`config.kdl` stays niri-flake's, so the DMS niri module (`inputs.dms.homeModules.niri`)
can wrap it in its own includes. DMS's files load after the generated config and win
where both set something. `dms-settings` matches them to `niri-core`: the DMS cursor
equals the niri cursor, and `niriLayoutGapsOverride = -2` keeps gaps out of
`dms/layout.kdl`. DMS's `outputs.kdl` places only the outputs DMS has seen, so leave
it out and keep outputs in Nix:

```nix
programs.dank-material-shell.niri.includes.filesToInclude = [
  "alttab" "binds" "colors" "cursor" "layout" "windowrules" "wpblur"
];
```

`dms/layout.kdl` also sets `tiled-state true` on every window, which `niri-core` does not.

## Zen

`zen-theme` only writes `~/.config/zen/customTheme.css`. Nothing loads that file until
the profile has a `userChrome.css` importing it and a `user.js` switching userChrome
on. `zen-profile` links both.

Zen creates the profile on first launch. Until `~/.config/zen/profiles.ini` exists the
activation step does nothing, so start Zen once and activate again.

The mods come from a pinned revision of `github:zen-browser/theme-store`, set in
`modules/zen-profile.nix`. The step copies `zen-themes.json` and `chrome/zen-themes/`
into the profile on every activation, so a mod toggled or updated in the browser is
reset by the next one. To add a mod, add its id to `lib.zen.mods`. To update the mods,
move the pin.

A profile has one `user.js`. If you want other prefs than `lib.zen.allPrefs`, do not
import `zen-profile`. Link your own file instead, from all groups or from some:

```nix
pkgs.writeText "user.js" (
  with inputs.nixentials.lib.zen;
  toUserJs (prefs.core // prefs.privacy // myPrefs)
)
```

The add-ons are an enterprise policy, which belongs to the package and not to the
profile. No module here installs Zen, so apply the policy where you install it. With
`github:youwen5/zen-browser-flake`, wrap the unwrapped package yourself. `.override`
on its `default` package drops `extraPolicies` without an error.

```nix
pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped {
  pname = "zen-browser";
  extraPolicies = inputs.nixentials.lib.zen.policies;
}
```

## Colours

`colors.nix` is the only place hex values are defined. Add to `smoothbrained` first,
then reference from the other palettes.

Consumers reach the palette through a module arg rather than a relative import, which
is what lets files outside this repo theme against it:

```nix
_module.args.colors = inputs.nixentials.lib.colors;
```

Modules then take `{ colors, ... }`. Non-MD3 apps read `colors.smoothbrained.*`; apps
using MD3 role semantics read `colors.md3.*`; terminal apps read `colors.dank16.*`.

## The mkOrder contract

**Read this before adding lines to the wezterm config.** `wezterm/config.nix` builds
its Lua by concatenating `extraConfig` chunks at explicit `lib.mkOrder` positions:

| Order | Chunk |
|---|---|
| 100 | setup: the `config` table, window, font, cursor, keybindings |
| 1000 (default) | colours, from `theme.nix` |
| 9999 | `return config` |

A chunk added at the default order lands **between the colours and the `return`**. That
is usually harmless but is silent when it is not, so pass `lib.mkOrder` explicitly.

## Checks

CI evaluates every `homeModules` output against both `nixos-unstable` and current
stable. Consumers pin their own nixpkgs and this flake follows theirs, so a consumer's
bump can break a module here. Catching it in this repo's CI beats catching it during a
server rebuild.
