{ inputs, outputs, lib, config, pkgs, system, ... }:


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
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    tmux
    tmuxp
    google-chrome
    git
    gh
    glow
    emacs
    pass      # password manager
    feh       # image viewer
    moc       # music on the command line
    zathura   # ebooks viewer
    tree
    ripgrep
    broot # filesystem browser
    exa # ls type thing
    bat # cat with syntax highlighting
    starship # custom prompt
    du-dust # disk usage
    fd # simpler find
    procs # ps in rust
    tealdeer # tldr --update
    bottom # top but rust
    skim # rusty grep
    # alacritty
    # helix
    # tldr
    unzip
    curl
    wget
     # languages related
    nixpkgs-fmt
    lldb
    haskell-language-server
    gopls
    cmake-language-server
    nixpkgs-review
    shfmt
    pyright
    rnix-lsp
    rust-analyzer
    sumneko-lua-language-server
    taplo-lsp
    taplo-cli
    yaml-language-server
    tree-sitter
    stylua
    black
  ];
  
  xdg.configFile = {
    "helix/languages.toml".text = import ./config/languages.nix { inherit pkgs inputs system; };
    # "helix/themes/catppuccin_macchiato.toml".text = builtins.readFile ./config/themes/catppuccin_macchiato.toml;
  };
  programs.helix = {
    enable = true;
  }; # helix
  
  programs.tmux = {
    enable = true;
    shortcut = "a";
    # aggressiveResize = true; -- Disabled to be iTerm-friendly
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
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
      set-environment -g COLORTERM "truecolor"
      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };

 # };

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
