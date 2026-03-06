{ ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      gcloud.disabled = true;
      add_newline = false;
      username = {
        style_user = "blue bold";
        style_root = "red bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = "🌐 ";
        format = "on [$hostname](bold red) ";
        trim_at = ".local";
        disabled = false;
      };
      nix_shell = {
        format = "via [$symbol$state]($style) ";
        impure_msg = "ι";
        pure_msg = "﻿ρ";
        symbol = "❄️";
      };
    };
  };
}

