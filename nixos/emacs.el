(setq comp-deferred-compilation nil)

(package-initialize)

;; Define XDG directories
(setq-default user-emacs-config-directory
              (concat (getenv "HOME") "/.config/emacs"))
(setq-default user-emacs-data-directory
              (concat (getenv "HOME") "/.local/share/emacs"))
(setq-default user-emacs-cache-directory
              (concat (getenv "HOME") "/.cache/emacs"))

;; Increase the threshold to reduce the amount of garbage collections made
;; during startups.
(let ((gc-cons-threshold (* 50 1000 1000))
      (gc-cons-percentage 0.6)
      (file-name-handler-alist nil)))

;; Display emojis in Emacs
(setf use-default-font-for-symbols nil)
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)

;; Remove suspend keys (annoying at best)
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;; Use pass for authentication
;; (auth-source-pass-enable)

;; Disable creation of lock-files named .#<filename>.
(setq-default create-lockfiles nil)

;; Unless the =$XGD_DATA_DIR/emacs/backup= directory exists, create it. Then set as backup directory.
(let ((backup-dir (concat user-emacs-data-directory "/backup")))
  (unless (file-directory-p backup-dir)
    (mkdir backup-dir t))
  (setq-default backup-directory-alist (cons (cons "." backup-dir) nil)))

;; Flycheck
(use-package flycheck
  :config (global-flycheck-mode))
(use-package flycheck-mypy)
(use-package flycheck-rust)
(use-package flycheck-elixir)

(add-to-list 'default-frame-alist '(font . "Inconsolata 8"))
(use-package nothing-theme)
(use-package zerodark-theme
  :config
  (progn
    (load-theme 'zerodark t)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (blink-cursor-mode -1)
    (scroll-bar-mode -1)
    (zerodark-setup-modeline-format)))

;; ;; Tree sitter
(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-mode-hook 'tree-sitter-hl-mode))
(use-package tree-sitter-langs
  :config
  (add-to-list 'tree-sitter-major-mode-language-alist '(markdown-mode . markdown))
  (add-to-list 'tree-sitter-major-mode-language-alist '(graphql-mode . graphql))
  )

;; Smooth-scroll
(use-package smooth-scrolling
  :config
  (progn
    (setq-default smooth-scroll-margin 2)))

(use-package vterm
  :defer 1
  :config
  (progn
    (setq vterm-max-scrollback 100000)
    (setq vterm-buffer-name-string "vterm %s")))

    ;; Display time in modeline
    (progn
      (setq display-time-24hr-format t)
      (display-time-mode 1))

    ;; Battery is useful too
    (display-battery-mode)

    (server-start)

    ))

;; Smart mode line
(use-package smart-mode-line-powerline-theme)
(use-package smart-mode-line
  :config
  (progn
    (setq sml/theme 'powerline)
    (setq sml/no-confirm-load-theme t)
    (sml/setup)))

;; Show which key triggers what command
(use-package which-key
  :config
  (progn
    (which-key-mode)))

;; Window switcher
(use-package ace-window
  :config
  (progn
    (ace-window-display-mode)))

;; Window management undo/redo
(winner-mode 1)

;; Basic code-style
(setq c-basic-indent 2)
(setq indent-line-function 'insert-tab)
(setq indent-tabs-mode nil)
(setq tab-stop-list '(2 4 12 16 20 24 28 32))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Debugging
(use-package realgud)

;; Nix
(use-package nix-mode
  :defer 2
  :mode "\\.nix$"
  :config (setq nix-indent-function 'nix-indent-line))

;; Global magit keys
(use-package magit
  :config
  (progn
    (global-set-key (kbd "C-x g") 'magit-status) ; Display the main magit popup
    (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup) ; Display keybinds for magit
    ))

;; PDF support
(use-package pdf-tools
    :config
    (pdf-tools-install)
    ;; Pdf and swiper does not work together
    (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward-regexp)
    )

(use-package highlight-parentheses
  :config
  (global-highlight-parentheses-mode))

;; Rust
(use-package rust-mode)
(use-package cargo)

;; scheme
(use-package geiser-chibi)

;; futhark
(use-package futhark-mode)

;; Matrix client
(use-package ement
  :config
  (progn
    (require 'ement-room-list)
    (defun matrix-connect ()
      (interactive)
      (ement-connect
       :uri-prefix "http://localhost:8008"
       :user-id "@leighgable:matrix.org"
       ))))

;; Various modes
(use-package jinja2-mode)
(use-package android-mode)
(use-package markdown-mode)
(use-package yaml-mode)
(use-package swift-mode)
(use-package kdeconnect)
(use-package handlebars-mode)
(use-package dockerfile-mode)
(use-package deadgrep
  :config (global-set-key (kbd "s-d") 'deadgrep))
(use-package bazel)
(use-package lua-mode)
(use-package cmake-mode)
(use-package meson-mode)
(use-package dts-mode)  ;; Device tree


(defvar multiple-cursors-keymap (make-sparse-keymap))
(use-package multiple-cursors
  :bind-keymap ("C-t" . multiple-cursors-keymap)
  :bind (:map multiple-cursors-keymap
              ("C-s" . mc--mark-symbol-at-point)
              ("C-w" . mark-word)
              ("C-n" . mc/mark-next-like-this)
              ("C-p" . mc/mark-previous-like-this)
              ("n" . mc/mark-next-like-this-symbol)
              ("p" . mc/mark-previous-like-this-symbol)
              ("C-a" . 'mc/mark-all-like-this)))



;; Org-exports
(use-package org)
(use-package ox-gfm
  :config
  (progn
    (eval-after-load "org"
      '(require 'ox-gfm nil t))
    ;; Syntax highlight in babel exports (has extra env requirements)
    (require 'ox-beamer)
    (require 'ox-latex)
    (setq org-export-allow-bind-keywords t)
    (setq org-latex-listings 'minted)
    (add-to-list 'org-latex-packages-alist '("" "minted" "listings"))
    (setq org-latex-pdf-process
          '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))))

;; ;; Autocomplete
(use-package company
  :config
  (progn
  (setq-default company-tooltip-minimum-width 15)
    (setq-default company-idle-delay 0.1)
    (use-package company-flx)
    (use-package company-statistics)
    (progn
      (with-eval-after-load 'company
        (company-flx-mode +1)))
    (progn
      (setq-default company-statistics-file
                    (concat user-emacs-data-directory
                            "/company-statistics.dat"))
      (company-statistics-mode))
    (global-company-mode)))

;; Global webpaste shortcuts
(use-package webpaste
  :defer 1
  :config
  (progn
    (global-set-key (kbd "C-c C-p C-b") 'webpaste-paste-buffer)
    (global-set-key (kbd "C-c C-p C-r") 'webpaste-paste-region)))

;; Smart parens
(use-package smartparens
  :config
  (progn
    (add-hook 'js-mode-hook #'smartparens-mode)
    (add-hook 'typescript-mode-hook #'smartparens-mode)
    (add-hook 'typescriptreact-mode-hook #'smartparens-mode)
    (add-hook 'html-mode-hook #'smartparens-mode)
    (add-hook 'python-mode-hook #'smartparens-mode)
    (add-hook 'nix-mode-hook #'smartparens-mode)
    (add-hook 'lua-mode-hook #'smartparens-mode)
    (add-hook 'talonscript-mode-hook #'smartparens-mode)
    (add-hook 'rust-mode-hook #'smartparens-mode)
    (add-hook 'ruby-mode-hook #'smartparens-mode)))

;; helm
(use-package helm
  :defer 2
  :diminish helm-mode
  :bind (("C-x C-f" . helm-find-files)
         ("M-x" . helm-M-x)
         ("C-x b" . helm-mini)
         ("C-x C-b" . helm-mini)
         ("M-y" . helm-show-kill-ring)
         :map helm-map
         ("<tab>" . helm-execute-persistent-action) ; Rebind TAB to expand
         ("C-i" . helm-execute-persistent-action) ; Make TAB work in CLI
         ("C-z" . helm-select-action)) ; List actions using C-z
  :config
  (progn
    (setq helm-buffer-max-length nil) ;; Size according to longest buffer name
    (setq helm-split-window-in-side-p t)

    ;; Case insensitive searches always
    (setq helm-locate-case-fold-search t)
    (setq helm-case-fold-search t)

    (helm-mode 1)))

(use-package helm-projectile
  :defer 2
  :bind (("C-x , p" . helm-projectile-switch-project)
         ("C-x , f" . helm-projectile-find-file)
         ("C-x , b" . projectile-ibuffer)
         ("C-x , i" . projectile-invalidate-cache)
         ("C-x , a" . helm-projectile-ag)
         ("C-x , k" . projectile-kill-buffers))
  :init
  (setq projectile-enable-caching t)
  :config
  (progn

    (defun my-projectile-project-find-function (dir)
      (let ((root (projectile-project-root dir)))
        (and root (cons 'transient root))))

    (projectile-mode)

    (with-eval-after-load 'project
      (add-to-list 'project-find-functions 'my-projectile-project-find-function))
  ))

(use-package swiper-helm
  :config
  (progn
    (global-set-key (kbd "C-s") 'swiper-helm)
    (global-set-key (kbd "C-r") 'swiper-helm)))
(use-package helm-rg)
  ;; :config (global-set-key (kbd "s-r") 'helm-rg))

;; Use view mode in read-only buffers
(setq view-read-only t)

;; Support direnv
(use-package envrc
  :config
  (progn
    (define-key envrc-mode-map (kbd "C-c e") 'envrc-command-map)
    (envrc-global-mode)))

;; JS/TS editing
(use-package web-mode
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(define-derived-mode typescriptreact-mode web-mode "TypescriptReact"
  "A major mode for tsx.")

(setq js-indent-level 2)
(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescriptreact-mode))
  :config
  (setq typescript-indent-level 2))
(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq js2-basic-offset 2))

;; LSP
(use-package yasnippet
  :config
  (yas-global-mode 1))
;; (use-package lsp-bridge
;;   :config
;;   (global-lsp-bridge-mode))

(use-package eglot
  :hook
  ((js-mode
    typescript-mode
    typescriptreact-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-hook 'web-mode-hook 'eglot-ensure)

  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure)

  (add-hook 'c++-mode-hook 'eglot-ensure)

  (add-hook 'javascript-mode-hook 'eglot-ensure)
  (add-hook 'js-mode-hook 'eglot-ensure)

  (add-hook 'sh-mode-hook 'eglot-ensure)

  (add-hook 'html-mode-hook 'eglot-ensure)
  (add-hook 'css-mode-hook 'eglot-ensure)

  (add-hook 'sh-mode-hook 'eglot-ensure)

  (add-hook 'nix-mode-hook 'eglot-ensure)
  (add-hook 'geiser 'eglot-ensure)
  (add-hook 'futhark-mode-hook 'eglot-ensure)
  (add-hook 'rust-mode-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'eglot-ensure)

  (cl-pushnew '((js-mode typescript-mode typescriptreact-mode) . ("typescript-language-server" "--stdio"))
              eglot-server-programs
              :test #'equal)

  )
(use-package eldoc-box
  :config
  (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-at-point-mode t))

;; (use-package lsp-bridge
;;   :init
;;   (global-lsp-bridge-mode)
;;   :config
;;   (setq lsp-bridge-nix-lsp-server "nil")
;;   (setq lsp-bridge-c-lsp-server "ccls")
;;   )

;; Voice control
(use-package talonscript-mode)
(use-package undo-fu)
(use-package voicemacs
  :config
  (progn
    (voicemacs--start-server)
    ;; Create interactive wrappers for voicemacs use
    (defun brightness-set (brightness)
      (interactive "P")
      (desktop-environment-brightness-set (format "-S %s" brightness)))
    (defun volume-set (volume)
      (interactive "P")
      (desktop-environment-volume-set (format "--set-volume %s" volume)))
    ))


;; Embedded dev
(use-package platformio-mode
  :config
  (add-hook 'c++-mode-hook (lambda ()
                             (platformio-conditionally-enable))))

;; (use-package fontaine
;;   :custom
;;   (fontaine-presets
;;    '((t :default-family "Monospace"
;;         :default-weight regular
;;         :default-height 100
;;         :fixed-pitch-height 1.0
;;         :fixed-pitch-serif-height 1.0
;;         :variable-pitch-family "Sans"
;;         :variable-pitch-height 1.0
;;         :bold-weight bold
;;         :italic-slant italic
;;         :line-spacing nil
;;         :fixed-pitch-family nil
;;         :fixed-pitch-weight nil
;;         :fixed-pitch-serif-family nil
;;         :fixed-pitch-serif-weight nil
;;         :variable-pitch-weight nil
;;         :bold-family nil
;;         :italic-family nil)
;;      (regular :default-height 100)
;;      (large :default-weight semilight
;;             :default-height 140
;;             :bold-weight extrabold)

;;      ;; (fantasque-sans-mono :default-family "Fantasque Sans Mono"
;;      ;;                      :default-height 105)

;;      ;; (iosevka-comfy :default-family "Iosevka Comfy Motion")
;;      ;; (iosevka-comfy-wide :default-family "Iosevka Comfy Wide Motion")

;;      (monaspace-argon :default-family "Monaspace Argon Var"
;;                       :default-height 100)
;;      (monaspace-argon-semi-bold :inherit monaspace-argon
;;                                 :default-weight semibold)
;;      (monaspace-neon :default-family "Monaspace Neon Var"
;;                      :default-height 100)
;;      (monaspace-neon-regular :inherit monaspace-neon
;;                              :default-weight regular)
;;      (monaspace-neon-normal :inherit monaspace-neon
;;                             :default-weight normal)
;;      (monaspace-neon-semi-bold :inherit monaspace-neon
;;                                :default-weight semibold)
;;      (monaspace-xenon :default-family "Monaspace Xenon Var"
;;                       :default-height 100)
;;      (monaspace-xenon-semi-bold :inherit monaspace-xenon
;;                                 :default-weight semibold))))

(use-package scad-mode)
