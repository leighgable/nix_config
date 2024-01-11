# helix.nix
{ config, lib, pkgs, ... }:

programs.helix = {
  enable = lib.mkDefault true;

  settings = {
    #theme = lib.mkDefault "base16_transparent";
    editor.lsp.display-messages = true;
    editor.lsp.display-inlay-hints = true;
    editor.true-color = true;
  };

home.sessionVariables.EDITOR = "hx";

home.packages = lib.mkBefore ((with pkgs; [
  lldb
  clang-tools
  marksman
  rust-analyzer
  black
  alejandra
]) ++ (with pkgs.nodePackages; [
  bash-language-server
  typescript-language-server
]));
