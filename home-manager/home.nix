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
    glow
    st        # terminal
    tiv       # terminal image display
    pass      # password manager
    feh       # image viewer
    moc       # music on the command line
    tree
    zellij
    ripgrep
    broot     # filesystem browser
    eza       # ls type thing
    bat       # cat with syntax highlighting
    dust      # disk usage
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
    clang-tools
    pyright
    python3
    texlive.combined.scheme-medium
    nixfmt-tree
    nil
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
    
    extraPackages = epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
      envrc
      flycheck
      nix-ts-mode
      magit
      geiser
      geiser-chibi
      futhark-mode
      python-mode
      auctex
      eglot
      sly
      markdown-mode
      multiple-cursors
    ];
  }; # emacs
 
  home.file = {
    ".emacs.d/init.el".text = ''
      ;; Load the main configuration file
      (load (locate-user-emacs-file "custom.el"))
    '';

    ".emacs.d/custom.el".text = ''
      ;; Nix-managed entry point

      ;; Ensure the languages directory is in the load-path
      (add-to-list 'load-path (expand-file-name "languages" user-emacs-directory))

      ;; Environment management
      (require 'envrc)
      (setq envrc-show-event-buffer t) ; Keep this on to debug initialization
      (envrc-global-mode 1)

      (setq visible-bell nil)

      ;; Start/Restart Eglot after the Nix environment is fully loaded
      (defun my-eglot-envrc-sync ()
        "Ensure Eglot starts or restarts with the correct Nix environment."
        (when (and (bound-and-true-p envrc-mode)
                   (not (string= envrc-mode "none")))
          (eglot-ensure)))

      (add-hook 'envrc-after-update-hook #'my-eglot-envrc-sync)

      (menu-bar-mode -1)

     ;; Duplicate line
     (global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y")


      ;; Inspired by `sk-grow-frame' from Sarir Khamsi [sarir.khamsi@raytheon.com]
;;;###autoload
(defun enlarge-frame (&optional increment frame) ; Suggested binding: `C-M-down'.
  "Increase the height of FRAME (default: selected-frame) by INCREMENT.
INCREMENT is in lines (characters).
Interactively, it is given by the prefix argument."
  (interactive "p")
  (set-frame-height frame (+ (frame-height frame) increment)))

;;;###autoload
(defun enlarge-frame-horizontally (&optional increment frame) ; Suggested binding: `C-M-right'.
  "Increase the width of FRAME (default: selected-frame) by INCREMENT.
INCREMENT is in columns (characters).
Interactively, it is given by the prefix argument."
  (interactive "p")
  (set-frame-width frame (+ (frame-width frame) increment)))

;;;###autoload
(defun shrink-frame (&optional increment frame) ; Suggested binding: `C-M-up'.
  "Decrease the height of FRAME (default: selected-frame) by INCREMENT.
INCREMENT is in lines (characters).
Interactively, it is given by the prefix argument."
  (interactive "p")
  (set-frame-height frame (- (frame-height frame) increment)))

;;;###autoload
(defun shrink-frame-horizontally (&optional increment frame) ; Suggested binding: `C-M-left'.
  "Decrease the width of FRAME (default: selected-frame) by INCREMENT.
INCREMENT is in columns (characters).
Interactively, it is given by the prefix argument."
  (interactive "p")
  (set-frame-width frame (- (frame-width frame) increment)))


      (setq major-mode-remap-alist
        '((c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)
          (python-mode . python-ts-mode)
          (markdown-mode . markdown-ts-mode)
          (nix-mode . nix-ts-mode)))

    ;; Global indentation defaults
    (setq-default
      indent-tabs-mode nil
      tab-width 2
      standard-indent 2)

      (add-hook 'before-save-hook #'delete-trailing-whitespace)

      (setq c-ts-mode-indent-offset 2
        c++-ts-mode-indent-offset 2)

     (with-eval-after-load 'cc-mode
       (setq c-default-style "google"
         c-basic-offset 2))

      (require 'multiple-cursors)

      (when (fboundp 'mc/edit-lines)
      ;; Suggested bindings
      (global-set-key (kbd "C-S-c C-S-c") #'mc/edit-lines)
      (global-set-key (kbd "C->")         #'mc/mark-next-like-this)
      (global-set-key (kbd "C-<")         #'mc/mark-previous-like-this)
      (global-set-key (kbd "C-c C-<")     #'mc/mark-all-like-this))

      (require 'setup-scheme)
      (require 'setup-futhark)
      (require 'setup-c-cpp)
      (require 'setup-python)
      (require 'setup-nix)
      (require 'setup-latex)
      (require 'setup-common-lisp)
      (require 'setup-markdown)
    '';

    ".emacs.d/languages/setup-nix.el".text = ''
      (require 'eglot)
      (add-hook 'nix-ts-mode-hook #'eglot-ensure)

      (add-hook 'nix-ts-mode-hook
                 (lambda ()
		   (add-hook 'before-save-hook
		         #'eglot-format-buffer
			 nil t)))
      (provide 'setup-nix)
    '';

    ".emacs.d/languages/setup-scheme.el".text = ''
      (require 'geiser)
      (require 'geiser-chibi)

      (setq geiser-default-implementation 'chibi)

      (add-hook 'scheme-mode-hook #'geiser-mode)
      (setq lisp-indent-offset 2)
      (provide 'setup-scheme)
    '';

    ".emacs.d/languages/setup-futhark.el".text = ''
      (require 'futhark-mode)
      (add-hook 'futhark-mode-hook #'eglot-ensure)
      (provide 'setup-futhark)
    '';

    ".emacs.d/languages/setup-c-cpp.el".text = ''

    (require 'eglot)
    (require 'cc-mode)

    ;; Google style for classic cc-mode
    (setq c-default-style "google"
      c-basic-offset 2)

    ;; Tree-sitter indentation
    (when (fboundp 'c-ts-mode)
    (setq c-ts-mode-indent-offset 2
        c++-ts-mode-indent-offset 2))

    (provide 'setup-c-cpp)
    '';

    ".emacs.d/languages/setup-python.el".text = ''
      (require 'python)
      (require 'eglot)

      (setq python-indent-offset 4)
      (provide 'setup-python)
    '';

    ".emacs.d/languages/setup-latex.el".text = ''
      (require 'tex-site)

      (setq TeX-auto-save t
            TeX-parse-self t
            TeX-save-query nil)

    (add-hook 'LaTeX-mode-hook #'visual-line-mode)
    (add-hook 'LaTeX-mode-hook #'flyspell-mode)
    (provide 'setup-latex)
  '';

  ".emacs.d/languages/setup-common-lisp.el".text = ''
    (require 'sly)
    
    (setq lisp-indent-offset 2)
    (setq inferior-lisp-program "sbcl")

    (add-hook 'lisp-mode-hook #'sly-mode)
    (provide 'setup-common-lisp)
  '';

  ".emacs.d/languages/setup-markdown.el".text = ''
    (require 'markdown-mode)
    (setq markdown-list-indent-width 2)
    (add-hook 'markdown-mode-hook #'visual-line-mode)
    (provide 'setup-markdown)
  '';
};


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
