{ pkgs, ... }:
{
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
      (setq futhark-indent-level 2)
      (add-to-list 'auto-mode-alist '("\\.fut\\'" . futhark-mode))
      (add-hook 'futhark-mode-hook #'eglot-ensure)
      (add-hook 'futhark-mode-hook 'futhark-fmt-on-save-mode)
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

}
