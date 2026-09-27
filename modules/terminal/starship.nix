{ ... }:
let
  c = import ../../lib/colors.nix;
  r_arrow = "";
  l_arrow = "";
  r_round = "";
  l_round = "";
in
{
  programs.starship = {
    enable = true;
    enableNushellIntegration = false;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = "[${l_round}](color_light)$os[${r_arrow}](bg:color_yellow fg:color_light)$directory[${r_arrow}](fg:color_yellow bg:color_aqua)$git_branch$git_status[${r_arrow}](fg:color_aqua bg:color_blue)$c$cpp$rust$golang$nodejs$php$java$kotlin$haskell$python\${env_var.IN_NIX_SHELL}[${r_arrow}](fg:color_blue bg:color_gray)$direnv$docker_context[${r_arrow}](fg:color_gray) ";
      right_format = "[${l_round}](color_black)$status$hostname[${l_arrow}](bg:color_black fg:color_gray)$cmd_duration[${l_arrow}](bg:color_gray fg:color_light)$time[${r_round}](color_light)";
      add_newline = false;

      line_break.disabled = false;

      palette = "smoothbrained";

      palettes.smoothbrained = {
        color_black = c.smoothbrained.black;
        color_white = c.smoothbrained.white;
        color_gray = c.smoothbrained.cool_gray;
        color_light = c.smoothbrained.warm_gray;
        color_darkest = c.gruvbox.bg;
        color_blue = c.gruvbox.blue;
        color_aqua = c.gruvbox.aqua;
        color_green = c.gruvbox.green;
        color_orange = c.gruvbox.orange;
        color_purple = c.beans.purple;
        color_red = c.gruvbox.red;
        color_yellow = c.gruvbox.yellow;
      };

      os = {
        disabled = false;
        style = "bg:color_light fg:color_darkest";
        format = "[$symbol ]($style)";
        symbols = {
          NixOS = "";
          Arch = "󰣇";
          Fedora = "󰣛";
          Linux = "󰌽";
          Macos = "󰀵";
          Android = "";
          Windows = "󰍲";
        };
      };

      directory = {
        style = "fg:color_white bg:color_yellow";
        format = "[  $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_white bg:color_aqua)]($style)";
      };

      git_status = {
        style = "bg:color_aqua";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        format = "[[($all_status $ahead_behind)](fg:color_white bg:color_aqua)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      c = {
        symbol = " ";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      cpp = {
        symbol = " ";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      rust = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      golang = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      php = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      java = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      kotlin = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      haskell = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };
      python = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_blue)]($style)";
      };

      direnv = {
        disabled = false;
        symbol = "󰲋 ";
        style = "bg:color_gray";
        format = "[[ $symbol$loaded/$allowed ](fg:color_white bg:color_gray)]($style)";
        allowed_msg = "✓";
        not_allowed_msg = "?";
        denied_msg = "✗";
        loaded_msg = "✓";
        unloaded_msg = "✗";
      };

      docker_context = {
        symbol = "";
        style = "bg:color_gray";
        format = "[[ $symbol( $context) ](fg:#83a598 bg:color_gray)]($style)";
      };

      hostname = {
        ssh_only = true;
        ssh_symbol = "@";
        style = "bg:color_black";
        format = "[[ $ssh_symbol$hostname ](fg:color_yellow bg:color_black)]($style)";
      };

      status = {
        disabled = false;
        format = "$symbol";
        symbol = "[✗ ](bold fg:color_red bg:color_black)";
        success_symbol = "[✓ ](bold fg:color_green bg:color_black)";
        sigint_symbol = "[INT ✗ ](bold fg:color_red bg:color_black)";
        not_found_symbol = "[? ](bold fg:color_orange bg:color_black)";
      };

      cmd_duration = {
        disabled = false;
        min_time = 2000;
        format = "[ took $duration  ](fg:color_white bg:color_gray)";
        show_milliseconds = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:color_gray";
        format = "[[ at $time  ](fg:color_darkest bg:color_light)]($style)";
      };

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:color_green)";
        error_symbol = "[❯](bold fg:color_red)";
        vimcmd_symbol = "[❮](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[❮](bold fg:color_purple)";
        vimcmd_replace_symbol = "[❮](bold fg:color_purple)";
        vimcmd_visual_symbol = "[❮](bold fg:color_yellow)";
      };

      env_var.IN_NIX_SHELL = {
        symbol = "";
        variable = "IN_NIX_SHELL";
        style = "bg:color_blue";
        format = "[[ $symbol $env_value ](bg:color_blue)]($style)";
      };

    };
  };
}
