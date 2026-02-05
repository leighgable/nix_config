{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
   ];

  home = {
    username = "leigh";
    homeDirectory = "/home/leigh";
  };
  
  home.packages = with pkgs; [
    google-chrome
    gh
    helvum    # patchbay gui for pipewire
    glow
    pass      # password manager
    feh       # image viewer
    moc       # music on the command line
    tree
    sioyek
    zellij
    ripgrep
    broot     # filesystem browser
    eza       # ls type thing
    bat       # cat with syntax highlighting
    dust   # disk usage
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
    ffmpeg
    wl-clipboard
    lynx
    iamb
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Leigh Gable";
      user.email = "leighgable@gmail.com";
      aliases = {
        ci = "commit";
        s = "status";
        co = "checkout";
      };
    };
    signing = { 
      key = "713802B5DD843245";
    };
    lfs.enable = true;
  };
  
 programs.emacs = {
   enable = true;
    package = pkgs.emacs-unstable-nox; 
    config = builtins.readFile ./emacs.el;
#init = {
#     enable = true;
#     packageQuickstart = false;
#     recommendedGcSettings = false;
#     usePackageVerbose = false;

#      prelude = builtins.readFile "${inputs.minimal-emacs-d}/init.el";
#     earlyInit =
#       (builtins.readFile "${inputs.minimal-emacs-d}/early-init.el");
      
#   }; # emacs init
  }; # emacs
  
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoreboth" ];
    historyIgnore = [
     "ls"
     "cd"
    ];
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      l = "eza -alh";
      ll = "eza -l";
      ls = "eza";
      ycwd = "echo \"My current directory is: $(pwd)\"";
      tl = "compgen -c | sk | xargs tldr";
      fman = "compgen -c | sk | xargs man";
      bg = "du -ah . | sort -hr | head -n 10";
      nnck = "rg | xargs du -sh | sort -hr | sk -m --header \"Select a file or directory\" --preview='cat $(filename{})' | awk '{print $2}'";
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
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
    # pinentryPackage = "gnome3";
  };



  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
