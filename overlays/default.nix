{ pkgs ? import <nixpkgs> { } }: 
# This file defines overlays
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    helix = prev.pkgs.helix.override {
      extraWrapperArgs = [
        "--set-default"
        "RUST_SRC_PATH"
        "${pkgs.rustPlatform.rustcSrc}/library"
      ];
      languageServers = with pkgs; [
        nodePackages.bash-language-server
        shellcheck
        yaml-language-server
        cmake-language-server
        taplo-lsp
        rnix-lsp
        alejandra
        python3Packages.python-lsp-server
        clang-tools
        rust-analyzer
        haskellPackages.haskell-language-server
        # inputs.nickel.packages.default
        # inputs.nil.packages.default
        gopls
        julia
        shfmt
        go
        black
      ];
    }; 
  };
}
