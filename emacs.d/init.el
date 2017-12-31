;;; wmedrano-emacs --- Summary:
;;;   Good support for C/C++, Clojure, Emacs Lisp, and Rust.
;;;   Includes auto completions, documentation lookup, and syntax checking.
;;;   VIM like keys bindings.
;;; Commentary:
;;;   will.s.medrano@gmail.com
;;; Code:


;;; Stop emacs from automatically modifying this file
(setq custom-file "/dev/null")

;;; package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(add-to-list 'load-path "~/.emacs.d/lisp")

(setq package-selected-packages
      '(ace-window ;; navigate windows
        all-the-icons ;; Icons
        all-the-icons-ivy ;; Icons for ivy
        cider ;; Clojure code introspection
        circe ;; IRC client
        clojure-mode ;; Clojure
        coffee-mode ;; CoffeeScript language support
        company ;; Autocomplete
        company-racer ;; Autocomplete backend for Rust
        counsel ;; Ivy integration
        counsel-projectile ;; Counsel for projectile
        dash ;; List utilities
        diff-hl ;; Highlight git differences
        diminish ;; Hide modeline
        evil ;; VIM keys
        evil-commentary ;; Comment out code
        evil-magit ;; Fix VIM keys for magit
        flycheck ;; Syntax checking
        flycheck-pos-tip ;; Show errors in tooltip
        flycheck-rust ;; Syntax checking backend for Rust
        flyspell ;; Spell checking
        flyspell-correct-ivy ;; Use ivy as flyspell correction frontend
        flx ;; Fuzzy scoring
        ivy ;; Emacs completions
        key-chord ;; Bind functions to key chords
        leuven-theme ;; Light theme
        lua-mode ;; Lua programming language
        magit ;; git integration
        monokai-theme ;; Dark theme
        neotree ;; File tree
        nyan-mode ;; Nyan cat in modeline
        projectile ;; Project management
        projectile-ripgrep ;; Search project with ripgrep
        spacegray-theme ;; Dark theme
        racer ;; Rust Auto CompletER
        rust-mode ;; Rust
        s ;; String utility library
        smex ;; Better M-x for counse-M-x
        spacemacs-theme ;; Light and dark theme
        swiper ;; Search buffers for text
        volatile-highlights ;; Highlight undo
        which-key ;; Discover prefix keys
        yaml-mode ;; Yaml syntax highlighting
        zenburn-theme ;; Dark theme
))

(defun my-install-packages ()
  "Refresh contents from melpa and install the necessary packages."
  (interactive)
  (package-refresh-contents)
  (package-install-selected-packages))

;; theming
(defun light-theme ()
  "Enable the light theme."
  (interactive)
  (require 'leuven-theme)
  (custom-set-faces '(hl-line ((t (:background "#D5F1CF" :underline nil)))))
  (disable-theme 'spacemacs-dark)
  (global-hl-line-mode t)
  (load-theme 'leuven t))
(defun dark-theme ()
  "Enable the dark theme."
  (interactive)
  (disable-theme 'leuven)
  (global-hl-line-mode -1)
  (load-theme 'spacemacs-dark t))
(defun init-theme ()
  (require 'neotree)
  (require 'nyan-mode)
  (require 'all-the-icons)
  (require 'all-the-icons-ivy)
  (setq inhibit-startup-screen t
	nyan-animate-nyancat t
	nyan-bar-length 10
	nyan-wavy-trail t
	neo-theme 'icons)
  (blink-cursor-mode -1)
  (dark-theme)
  (nyan-mode t)
  (nyan-start-animation)
  (custom-set-faces '(default ((t (:family "Fira Mono" :slant normal :width normal :height 132))))))
(init-theme)

;; Disable nags
(defun init-disable-nags ()
  (setq inhibit-startup-screen t)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))
(init-disable-nags)

;; Misc
(require 'which-key)
(setq browse-url-browser-function 'browse-url-chrome)
(which-key-mode)
(defalias 'yes-or-no-p 'y-or-n-p)

;; vim like keys
(require 'evil)
(require 'evil-commentary)
(require 'key-chord)
(evil-mode t)
(key-chord-mode t)
(evil-commentary-mode)
(key-chord-define evil-insert-state-map "jj" #'evil-normal-state)
(define-key evil-normal-state-map (kbd "gs") #'evil-ex-sort)
(define-key evil-motion-state-map (kbd "J") #'evil-scroll-down)
(define-key evil-normal-state-map (kbd "J") nil)
(define-key evil-motion-state-map (kbd "K") #'evil-scroll-up)
(define-key evil-normal-state-map (kbd "K") nil)
(define-key evil-motion-state-map (kbd "L") #'evil-scroll-line-down)
(define-key evil-motion-state-map (kbd "H") #'evil-scroll-line-up)
(define-key evil-normal-state-map (kbd "TAB") #'indent-for-tab-command)
(define-key evil-visual-state-map (kbd "TAB") #'indent-for-tab-command)
(define-key evil-motion-state-map (kbd "q") #'quit-window)
(define-key evil-motion-state-map (kbd "gd") #'xref-find-definitions)
(define-key evil-motion-state-map (kbd "gx") #'xref-find-references)
(define-key evil-motion-state-map (kbd "gX") #'xref-find-apropos)
(define-key evil-motion-state-map (kbd "gr") #'revert-buffer)
(define-key evil-normal-state-map (kbd "C-d") #'evil-join)
(define-key evil-normal-state-map (kbd "RET") #'evil-next-line)
(define-key evil-motion-state-map (kbd "RET") nil)

;; undo
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; file refresh
(require 'autorevert)
(setq auto-save-file-name-transforms `((".*" "~/.saves/" t))
      auto-save-list-file-prefix "~/.saves/"
      backup-directory-alist '(("." . "~/.saves")))
(global-auto-revert-mode t)
(define-key evil-normal-state-map (kbd "gr") 'revert-buffer)

;; buffer formatting
(setq-default indent-tabs-mode nil
              fill-column 80)
(electric-pair-mode t)
(global-linum-mode t)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; version control
(require 'diff-hl)
(require 'diff-hl-flydiff)
(require 'magit)
(require 'evil-magit)
(setq auto-revert-check-vc-info t
      diff-hl-flydiff-delay 1.0
      magit-commit-show-diff nil)
(global-diff-hl-mode t)
(diff-hl-flydiff-mode t)

;; file tree
(require 'neotree)
(add-to-list 'evil-motion-state-modes 'neotree-mode)

;; emacs/project management
(require 'counsel)
(require 'counsel-projectile)
(require 'flx)
(require 'ivy)
(require 'projectile)
(setq projectile-ignored-project-function (lambda (root)
                                                  (or (string-match "/tmp/*" root)
                                                      (string-match ".*\.cargo/*" root))))
;; (setq ivy-re-builders-alist
;;       '((ivy-switch-buffer . ivy--regex-plus)
;;         (t . ivy--regex-fuzzy)))
(setq ivy-height 24
      ivy-fixed-height-minibuffer t
      ivy-wrap t)
(counsel-mode)
(ivy-mode)
(counsel-projectile-mode)
(projectile-mode t)
(global-set-key (kbd "M-x") #'counsel-M-x)
(define-key evil-motion-state-map (kbd "gp") 'projectile-command-map)
(define-key evil-normal-state-map (kbd "gp") nil)
(define-key projectile-mode-map (kbd "C-c p s") 'projectile-ripgrep)
(all-the-icons-ivy-setup)

;; Window management
(require 'ace-window)
(defun ace-revert-buffer (window)
  "Revert the buffer at WINDOW without asking the user for confirmation."
  (with-selected-window window (revert-buffer t t)))
(defun ace-split-window-fair (&optional window)
  "Split WINDOW into 2."
  (aw-split-window-fair (or window (selected-window))))
(setq aw-dispatch-always t
      aw-fair-aspect-ratio 2.35
      aw-scope 'frame
      window-min-width 12
      window-min-height 5)
(setq aw-dispatch-alist
  '((?x aw-delete-window " Ace - Delete Window")
    (?m aw-swap-window " Ace - Swap Window")
    (?M aw-move-window " Ace - Move Window")
    (?n aw-flip-window)
    (?c ace-split-window-fair)
    (?v aw-split-window-vert " Ace - Split Vert Window")
    (?r ace-revert-buffer "Revert buffer")
    (?b aw-split-window-horz " Ace - Split Horz Window")
    (?i delete-other-windows " Ace - Delete Other Windows")
    (?o delete-other-windows)))
(global-set-key (kbd "C-c w") 'ace-window)
(define-key evil-motion-state-map (kbd "gw") 'ace-window)
(define-key evil-normal-state-map (kbd "gw") nil)

;; Text search
(require 'counsel-projectile)
(require 'swiper)
(define-key evil-motion-state-map (kbd "g/") 'counsel-projectile-rg)
(define-key evil-normal-state-map (kbd "g/") nil)
(key-chord-define evil-motion-state-map (kbd "//") 'swiper)
(key-chord-define evil-motion-state-map (kbd "??") 'swiper-all)

;; Code documentation
(defun init-code-documentation ()
  (interactive)
  (setq eldoc-echo-area-use-multiline-p t)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
  (add-hook 'clojure-mode-hook #'eldoc-mode))
;; (init-code-documentation)

;; Code references
(setq-default xref-backend-functions '()) ;; disable etags xrefs

;; Autocompletion
(defun init-autocomplete ()
  (interactive)
  (require 'company)
  (setq company-selection-wrap-around t
	company-tooltip-align-annotations t
	company-tooltip-limit 20
	company-tooltip-minimum 20
	company-tooltip-minimum-width 60)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "C-h") #'company-show-doc-buffer)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map [return] nil)
  (define-key company-active-map [tab] #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (add-to-list 'company-backends 'company-racer)
  (add-hook 'emacs-lisp-mode-hook #'company-mode)
  (add-hook 'rust-mode-hook #'company-mode)
  (add-hook 'clojure-mode-hook #'company-mode))
;; (init-autocomplete)

;; Syntax checking
(defun init-syntax-checking ()
  (interactive)
  (require 'flycheck)
  (require 'flycheck-pos-tip)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (add-hook 'flycheck-mode-hook #'flycheck-pos-tip-mode)
  (add-hook 'rust-mode-hook #'flycheck-mode)
  (add-hook 'clojure-mode-hook #'flycheck-mode)
  (add-hook 'emacs-lisp-mode-hook #'flycheck-mode)
  (define-key evil-normal-state-map (kbd "ge") 'flycheck-next-error))
;; (init-syntax-checking)

;; Spell checking
(defun init-spell-checking ()
  (interactive)
  (require 'flyspell)
  (require 'flyspell-correct)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (add-hook 'text-mode-hook 'flyspell-mode)
  (global-set-key (kbd "C-c a") 'flyspell-correct-previous-word-generic))
;; (init-spell-checking)

;; Clojure
(add-hook 'cider-repl-mode-hook 'evil-insert-state)

;; Rust
(setenv "RUST_SRC_PATH" (expand-file-name "~/src/rust/src"))
;; TODO: figure out why initial value of racer-rust-src-path is correct, but
;; then it switches to bogus value
(setq-default racer-rust-src-path nil)
(add-to-list 'exec-path "~/.cargo/bin")
(setenv "PATH" (concat "~/.cargo/bin:" (getenv "PATH")))
(add-hook 'rust-mode-hook 'rust-enable-format-on-save)
(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'rust-mode-hook
          (lambda ()
            (evil-define-key 'motion racer-mode-map (kbd "gd") 'racer-find-definition)
            (setq-local fill-column 100)
            (setq-local projectile-tags-command "~/.cargo/bin/rusty-tags emacs")
            (setq-local projectile-project-compilation-cmd "cargo build")
            (setq-local projectile-project-run-cmd "RUST_LOG=warn cargo run")
            (setq-local projectile-project-test-cmd "cargo test")))

;; Miscellaneous modes that don't work well with evil.
(define-key compilation-mode-map (kbd "g") nil)
(define-key compilation-mode-map (kbd "r") 'revert-buffer)
(add-to-list 'evil-motion-state-modes 'profiler-report-mode)

;; Hide modeline entries
(diminish 'auto-revert-mode)
(diminish 'counsel-mode)
(diminish 'evil-commentary-mode)
(diminish 'flyspell-mode)
(diminish 'ivy-mode)
(diminish 'undo-tree-mode)
(diminish 'volatile-highlights-mode)
(diminish 'which-key-mode)

(if (file-exists-p "~/local/emacs.el")
    (load-file "~/local/emacs.el"))

(provide 'init)
;;; init.el ends here
