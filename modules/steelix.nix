# steelix, the Helix fork with the Steel plugin system (helix-editor/helix#8675), as `sx` next
# to the release `hx`, with its plugins. Both read the same ~/.config/helix; release hx ignores
# init.scm and helix.scm. Needs homeModules.editor, whose beans-dark theme sx builds on.
# flake.nix passes in the helix-plugins input and imports its home-manager module.
helix-plugins:
{ pkgs, ... }:
let
  plugins = helix-plugins.legacyPackages.${pkgs.stdenv.hostPlatform.system}.helixPlugins;
in
{
  home.packages = [ (pkgs.writeShellScriptBin "sx" ''exec ${pkgs.steelix}/bin/hx "$@"'') ];

  # helix-plugins' module makes steelix the default package, which would turn `hx` into it too.
  programs.helix.package = pkgs.helix;

  # Linked into ~/.local/share/steel/cogs/<name>. vista.hx and scooter.hx are left out, as
  # they do not run on this steelix yet. A plugin that fails to load stops init.scm there, so
  # nothing required after it loads either.
  programs.helix.plugins = {
    # scopeline stops its bar at forest.hx's sidebar, which calls scopeline-set-forest-clip!.
    # Grove only clips the editor, so the bar drew under the tree. This makes Grove call the
    # hook whenever its width changes, as forest-publish-clip! does.
    grove-hx = plugins.grove-hx.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace src/adapters/helix/component.scm --replace-fail \
          '(set! *clip-width* width)))' \
          '(set! *clip-width* width)
            (let ([args (string-append " (quote " (symbol->string *clip-side*) ") "
                                       (number->string width) ")")])
              (with-handler (lambda (_) #f)
                (eval-string (string-append "(scopeline-set-forest-clip!" args))))))'
      '';
    });
    inherit (plugins)
      fresco-hx
      oil-hx
      scopeline-hx
      smooth-scroll-hx
      who-hx
      yank-flash-hx
      ;
    # Not packaged in helix-plugins-nix. The key is the package-name in its cog.scm.
    git-panel = pkgs.fetchFromGitHub {
      owner = "cmltaWt0";
      repo = "git-panel.hx";
      rev = "a6ea22ada2ebb6a33cd34e216e41aeda919a4a5e";
      hash = "sha256-ZFRc4yXo8IDLqxtCd4prZraiG7NN7JeDo9z1S502/hI=";
    };
    session-hx = pkgs.fetchFromGitHub {
      owner = "sohunpatel";
      repo = "session.hx";
      rev = "0affeaa135566a852d3dcd6d281a2ea4471f092a";
      hash = "sha256-vjavJSmqA4zDOkg1g6Q15ncnEcdEnBVfYBrzgITW2rs=";
    };
  };

  # Names required here become typed commands. session.hx's README puts its require in
  # helix.scm, but that file is a module that only exports what it `provide`s, so
  # :session-create stayed unknown there.
  xdg.configFile."helix/init.scm".text = ''
    (require "oil/oil.scm")
    (oil-configure! #false #false)

    (require "who/who.scm")

    (require "fresco/fresco.scm")
    (fresco-start!)

    (require "session-hx/session.scm")

    (require "scopeline/scopeline.scm")
    (require "yank-flash/yank-flash.scm")
    (require "git-panel/git-panel.scm")

    (require "helix/keymaps.scm")

    ; Grove starts hidden and shows only while focused (Space e). Space E docks it for this
    ; process, and pressing it again hides it. `sx .` opens Helix's own file picker before
    ; Grove mounts, so open a directory with `sx -w dir`.
    (require "grove/grove.scm")
    ; The rail between the tree and the editor takes the split separator's colors, the editor
    ; background, so the line numbers are the only divider.
    (grove-start! #:visibility 'focused
                  #:theme (grove-theme #:rail "ui.window"))

    ; Built into steelix, not into release hx, whose config.toml would reject the key.
    (require "helix/configuration.scm")
    (require (prefix-in helix. "helix/commands.scm"))
    (rainbow-brackets #t)
    (helix.theme "beans-dark-rainbow")

    ; Bound here and not in config.toml, which release hx reads too and where these
    ; commands do not exist.
    (require "smooth-scroll/smooth-scroll.scm")

    (keymap (global)
      (normal
        (C-d ":half-page-down-smooth")
        (C-u ":half-page-up-smooth")
        (pageup ":page-up-smooth")
        (pagedown ":page-down-smooth")
        (space
          (G ":git-panel")
          (e ":grove-focus!")
          (E ":grove-visibility-toggle!"))))
  '';
  # Steelix's rainbow brackets cycle through the theme's `rainbow` list, or ANSI colors without
  # one. Release hx 25.07 has no such key and warns about it, so only sx loads this theme.
  programs.helix.themes.beans-dark-rainbow = {
    inherits = "beans-dark";
    rainbow = [
      "yellow"
      "light_purple"
      "light_blue"
      "dark_green"
      "orange"
      "red"
    ];
  };

  # Empty, but declared: steelix creates the file at startup if it is missing.
  xdg.configFile."helix/helix.scm".text = "";
}
