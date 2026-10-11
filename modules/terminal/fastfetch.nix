{ config, lib, ... }:
{
  options.fastfetch.logo = lib.mkOption {
    type = lib.types.attrs;
    # fastfetch renders the PNG itself and sizes it from the terminal's cell size, so the
    # info column lines up at any font size. A pre-rendered sixel needs a hand-tuned height.
    default = {
      type = "sixel";
      source = "${../../icons/nix-logo-gold.png}";
      width = 45;
      padding = {
        left = 2;
        right = 4;
      };
    };
  };

  options.fastfetch.modules = lib.mkOption {
    type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
    default = [
      "title"
      "separator"
      "os"
      {
        type = "command";
        key = "Generation";
        text = ''
          gen=$(readlink /nix/var/nix/profiles/system | grep -oP '\d+')
          date=$(stat -c '%y' /nix/var/nix/profiles/system | cut -d'.' -f1 | cut -d':' -f1-2)
          echo "$gen ($date)"
        '';
      }
      "host"
      "kernel"
      "uptime"
      "packages"
      "shell"
      {
        type = "display";
        format = ''{width}x{height} in {inch}", {refresh-rate} Hz'';
      }
      "wm"
      "cpu"
      {
        type = "gpu";
        format = "{name}";
      }
      "memory"
      "swap"
      "disk"
      "localip"
      "break"
      "colors"
      "break"
    ];
  };

  config.xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    logo = config.fastfetch.logo;
    modules = config.fastfetch.modules;
  };
}
