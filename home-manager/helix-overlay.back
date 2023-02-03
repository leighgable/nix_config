{
  inputs
}: let
  inherit (inputs.nixpkgs) pkgs;
in {
  myhelix = pkgs.helix.override {
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
      inputs.nickel.packages.default
      inputs.nil.packages.default
      gopls
      shfmt
      go
      black
    ];
  };
}
