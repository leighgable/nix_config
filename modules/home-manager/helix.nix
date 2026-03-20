{ pkgs, ... }:
{
  programs.helix = with pkgs; {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      tree-sitter-grammars.tree-sitter-scheme
      clang-tools
      marksman
      nil
      nixpkgs-fmt
      (python3.withPackages (p: (with p; [
        black
        isort
        python-lsp-black
        ruff
      ])))
      rust-analyzer
    ];

    settings = {
      theme = "snazzy"; 
      
      editor = {
        color-modes = true;
        cursorline = true;
        bufferline = "multiple";

        soft-wrap.enable = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
          ignore = false;
        };

        indent-guides = {
          character = "┊";
          render = true;
          skip-levels = 1;
        };

        lsp = {
          display-inlay-hints = true;
          display-messages = true;
          display-signature-help-docs = true;
        };

        statusline = {
          left = [ "mode" "file-name" "spinner" "read-only-indicator" "file-modification-indicator" ];
          right = [ "diagnostics" "selections" "register" "file-type" "file-line-ending" "position" ];
          mode.normal = "N";
          mode.insert = "I";
          mode.select = "S";
        };
      };
    };
    languages = { 
      language = [{
    name = "nix";
    auto-format = true;
    formatter.command = lib.getExe pkgs.nixfmt;
  }];
    };
  };
}
