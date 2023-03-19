{ inputs, outputs, lib, config, pkgs, system, ... }:


{
  # add home-manager modules here
  imports = import ./programs;
             # nix-colors.homeManagerModule
             # ];

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
      ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

  # colorScheme = nix-colors.colorSchemes.fruit-soda;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "leigh";
  home.homeDirectory = "/home/leigh";
  
  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "google-chrome";
    # TERMINAL = "console";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
#   fonts.fontconfig.enable = true;
#   home.packages = [
#     (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
#   ]; # someday!

  home.packages = with pkgs; [
    # tmux
    # tmuxp
    # wezterm  # multiplexer shell
    google-chrome
    git
    nix-direnv
    gh
    glow
    emacs
    pass      # password manager
    feh       # image viewer
    moc       # music on the command line
    zathura   # ebooks viewer
    tree
    sioyek
    ripgrep
    broot     # filesystem browser
    exa       # ls type thing
    bat       # cat with syntax highlighting
    # starship
    du-dust   # disk usage
    fd        # simpler find
    procs     # ps in rust
    tealdeer  # tldr --update
    bottom    # top but rust
    skim      # rusty grep
    zoxide    # directory jumper
    # helix
    # tldr
    xsel
    unzip
    curl
    wget
              # languages related
    nixpkgs-fmt
    nodePackages.typescript-language-server
    nodePackages.ocaml-language-server
    texlab
    clojure-lsp  
    erlang-ls
    elixir_ls
    nil
    llvmPackages_9.libclang  # provides clangd lsp
    lldb
    haskell-language-server
    gopls
    cmake-language-server
    nixpkgs-review
    shfmt
    pyright
    rust-analyzer
    rustfmt
    sumneko-lua-language-server
    taplo-lsp
    taplo-cli
    yaml-language-server
    tree-sitter
    stylua
    # black
    python311Packages.pylsp-mypy
  ];
  

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
  programs.tmux.tmuxp.enable = true;
  programs.tmux = {
    enable = true;
    shortcut = "a";
    # aggressiveResize = true; -- Disabled to be iTerm-friendly
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 20;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set -g allow-passthrough 'on' # just added, not sure about quotes
      set-environment -g COLORTERM "truecolor"
      set-option -g utf-8 on
      
      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  }; 
  
  programs.bash.enable = true;
  
  programs.dircolors.enable = true;
  programs.dircolors.enableBashIntegration = true;
  programs.dircolors.extraConfig = ''
    TERM xterm-256color
  '';
  programs.dircolors.settings = {
    ".iso" = "01;31"; # .iso files bold red like .zip and other archives
    ".gpg" = "01;33"; # .gpg files bold yellow
    # Images to non-bold magenta instead of bold magenta like videos
    ".bmp"   = "00;35";
    ".gif"   = "00;35";
    ".jpeg"  = "00;35";
    ".jpg"   = "00;35";
    ".mjpeg" = "00;35";
    ".mjpg"  = "00;35";
    ".mng"   = "00;35";
    ".pbm"   = "00;35";
    ".pcx"   = "00;35";
    ".pgm"   = "00;35";
    ".png"   = "00;35";
    ".ppm"   = "00;35";
    ".svg"   = "00;35";
    ".svgz"  = "00;35";
    ".tga"   = "00;35";
    ".tif"   = "00;35";
    ".tiff"  = "00;35";
    ".webp"  = "00;35";
    ".xbm"   = "00;35";
    ".xpm"   = "00;35";
  };
  
  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[BASH](bright-white) ";
      zsh_indicator = "[ZSH](bright-white) ";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    hostname = {
      style = "bright-green bold";
      ssh_only = true;
    };
    nix_shell = {
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = "שׂ";
      style = "bright-yellow bold";
    };
    git_commit = {
      only_detached = true;
      format = "[ﰖ$hash]($style) ";
      style = "bright-yellow bold";
    };
    git_state = {
      style = "bright-purple bold";
    };
    git_status = {
      style = "bright-green bold";
    };
    directory = {
      read_only = " ";
      truncation_length = 0;
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "bright-blue";
    };
    jobs = {
      style = "bright-green bold";
    };
    character = {
      success_symbol = "[\\$](bright-green bold)";
      error_symbol = "[\\$](bright-red bold)";
    };
  }; # starship
  
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

}
