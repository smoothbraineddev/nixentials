{
  description = "Shared look, terminal and session config for NixOS + home-manager hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }:
    {
      lib = {
        colors = import ./lib/colors.nix;
        niri = import ./lib/niri.nix;
        zen = import ./lib/zen.nix;
      };

      homeModules = {
        terminal = ./modules/terminal;
        editor = ./modules/editor;

        niri-core = ./modules/niri;

        niri-binds = {
          programs.niri.settings.binds = self.lib.niri.allBinds;
        };
        niri-rules = {
          programs.niri.settings.window-rules = self.lib.niri.allRules;
        };

        toolkit = ./modules/toolkit;
        dms-theme = ./modules/dms-theme.nix;
        zen-theme = ./modules/zen-theme.nix;
        zen-profile = ./modules/zen-profile.nix;
      };

      nixosModules.session = ./nixos/session.nix;
    };
}
