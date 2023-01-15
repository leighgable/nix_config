{ inputs, outputs, lib, config, pkgs, ... }:


{
  # add home-manager modules here
  imports = [];

  nixpkgs = {
    # add overlays here
    overlays = [
      # add overlays from flake exports (from overlays and pkgs dir):
      # outputs.overlays.modifications
      # outputs.overlays.additions
      # can also add overlays exported from other flakes:
      # ex neovim-nightly-overlay.overlays.default
      # or define inline:
      # (final: prev: {
      #     hi = final.hello.overrideAttrs (oldAttrs: {
      #        patches = [ ./change-hello-to-hi.patch ];
      #     });
      #  })
      # ( import ./helix-overlay.nix )
      ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "leigh";
  home.homeDirectory = "/home/leigh";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

  home.packages = with pkgs; [
    tmux
    google-chrome
    git
    gh
    emacs
    pass      # password manager
    feh       # image viewer
    moc       # music on the command line
    zathura   # ebooks viewer
    tree
    ripgrep
    helix
  ];

  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "absolute";
        indent-guides.render = true;
      };
    };
    # languages = with pkgs; [
    #   nodePackages.bash-language-server
    #   shellcheck
    #   yaml-language-server
    #   cmake-language-server
    #   taplo-lsp
    #   rnix-lsp
    #   alejandra
    #   python3Packages.python-lsp-server
    #   clang-tools
    #   rust-analyzer
    #   haskellPackages.haskell-language-server
    #   # inputs.nickel.packages.default
    #   # inputs.nil.packages.default
    #   gopls
    #   shfmt
    #   go
    #   black  
    # ];
  };

  programs.git = {
    enable = true;
    userName = "Leigh Gable";
    userEmail = "leighgable@gmail.com";
    aliases = {
      ci = "commit";
      s = "status";
      co = "checkout";
    };
  };
  
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
  
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

}
