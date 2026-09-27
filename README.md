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
| `homeModules.terminal` | wezterm, starship, fastfetch, zsh, nushell, aliases, broot, yazi |
| `homeModules.editor` | helix settings, languages, theme |
| `homeModules.niri-core` | animations, input, layout, misc, startup, theme. No binds, rules or outputs |
| `homeModules.niri-binds` | Every `lib.niri.binds` group, applied |
| `homeModules.niri-rules` | Every `lib.niri.rules` group, applied |
| `homeModules.toolkit` | gtk, qt |
| `homeModules.dms-theme` | The DMS colour mapping only |
| `homeModules.zen-theme` | The Zen CSS only |
| `nixosModules.session` | niri, xwayland, portals, greetd + tuigreet, gnome-keyring, session env vars |

## Using it

Follow your own nixpkgs, so only one lands in your closure:

```nix
inputs.nixentials = {
  url = "gitlab:smoothbraineddev/nixentials";
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
