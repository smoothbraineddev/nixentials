{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.bacon-ls = {
      command = "bacon-ls";
    };

    language-server.nil = {
      command = "nil";
    };

    language-server.phpactor = {
      command = "phpactor";
      args = [ "language-server" ];
    };

    language-server.pyright = {
      command = "pyright-langserver";
      args = [ "--stdio" ];
    };

    language-server.rust-analyzer.config = {
      inlayHints = {
        bindingModeHints.enable = false;
        closureReturnTypeHints.enable = "with_block";
        discriminantHints.enable = "fieldless";
      };
      check.command = "clippy";
    };

    language-server.taplo = {
      command = "taplo";
      args = [
        "lsp"
        "stdio"
      ];
    };

    language = [
      {
        name = "nix";
        auto-format = true;
        language-servers = [ "nil" ];
      }
      {
        name = "php";
        language-servers = [ "phpactor" ];
        formatter = {
          command = "php-cs-fixer-stdin";
        };
        auto-format = true;
        file-types = [
          "php"
          "phtml"
          "php3"
          "php4"
          "php5"
          "phps"
        ];
        roots = [
          "composer.json"
          ".git"
        ];
        indent = {
          tab-width = 4;
          unit = "    ";
        };
      }
      {
        name = "python";
        language-servers = [ "pyright" ];
      }
      {
        name = "rust";
        language-servers = [
          "rust-analyzer"
          "bacon-ls"
        ];
      }
      {
        name = "toml";
        language-servers = [ "taplo" ];
      }
    ];
  };

  xdg.configFile."phpactor/phpactor.json".text = builtins.toJSON {
    "language_server_phpstan.enabled" = true;
    "language_server_phpstan.bin" = "${pkgs.phpstan}/libexec/phpstan/phpstan.phar";
    "language_server_phpstan.level" = "5";
  };
}
