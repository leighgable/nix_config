# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    (import ../modules/home-manager/helix.nix {inherit pkgs config lib;})
    # (import ./programs/helix { inherit pkgs lib inputs ; })
    # (import ./programs/helix/languages.nix { inherit pkgs lib; })
    # (import ./programs/zellij { inherit pkgs config; })
    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "leigh";
    homeDirectory = "/home/leigh";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      rust-lang.rust-analyzer
      xaver.clang-format
      ms-python.python
      ms-python.black-formatter
      ms-toolsai.jupyter
      yzhang.markdown-all-in-one
    ];
  };

  home.packages = with pkgs; [
    pkgs.unstable.google-chrome 
    nix-direnv
    gh
    glow
    pass      # password manager
    feh       # image viewer
    moc       # music on the command line
    tree
    sioyek
    # helix
    zellij
    ripgrep
    broot     # filesystem browser
    eza       # ls type thing
    bat       # cat with syntax highlighting
    du-dust   # disk usage
    fd        # simpler find
    procs     # ps in rust
    tealdeer  # tldr --update
    bottom    # top but rust
    skim      # rusty grep
    zoxide    # directory jumper
    xsel
    unzip
    curl
    wget
  ];
  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Leigh Gable";
    userEmail = "leighgable@gmail.com";
    signing = { 
      key = "713802B5DD843245";
    };
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
  
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "713802B5DD843245";
      no-comments = false;
      # Get rid of the copyright notice
      no-greeting = true;
      # Because some mailers change lines starting with "From " to ">From "
      # it is good to handle such lines in a special way when creating
      # cleartext signatures; all other PGP versions do it this way too.
      no-escape-from-lines = true;
      # Use a modern charset
      charset = "utf-8";
      ### Show keys settings
      # Always show long keyid
      keyid-format = "0xlong";
      # Always show the fingerprint
      with-fingerprint = true;
      # Automatic key location
      auto-key-locate = "cert pka ldap keyserver";
      ### Private keys password protection options
      # Cipher algorithm
      s2k-cipher-algo = "AES256";
      # Hashing algorithm
      s2k-digest-algo = "SHA512";
      # Add a 8-byte salt and iterate password hash
      s2k-mode = "3";
      # Number of password hashing iterations
      s2k-count = "65000000";
      ### Change defaults algorithms
      # Personal symmetric algos
      personal-cipher-preferences = "AES256 TWOFISH CAMELLIA256 AES192 CAMELLIA192 AES CAMELLIA128 BLOWFISH";
      # Personal hashing algos
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224 SHA1 RIPEMD160 MD5";
      # Personal compression algos
      personal-compress-preferences = "ZLIB BZIP2 ZIP";
      # Default algorithms
      default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 TWOFISH CAMELLIA256 AES192 CAMELLIA192 AES CAMELLIA128 BLOWFISH ZLIB BZIP2 ZIP Uncompressed";
      # Certificate hashing algorithm
      cert-digest-algo = "SHA512";
      # Minimize some attacks on subkey signing (from gpg docs)
      require-cross-certification = true;
      # Get rid of version info in output files
      no-emit-version = true;
    };
  };
  
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
