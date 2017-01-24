;;; wmedrano-emacs --- Summary:
;;;   Good support for C/C++, Clojure, Emacs Lisp, and Rust.
;;;   Includes auto completions, documentation lookup, and syntax checking.
;;;   Uses evil for VIM like keys bindings.
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
      '(
        ace-window ;; window jumping
        all-the-icons ;; icons
        apropospriate-theme ;; Dark and Light theme
        cider ;; Clojure REPL support
        clang-format ;; Format C/C++ buffers
        clojure-mode ;; Clojure syntax
        company ;; Autocompletions
        company-flx ;; Allow fuzzy autocompletions
        company-irony ;; Irony backend for company
        company-irony-c-headers ;; Irony headers for autocompletion
        company-racer ;; Rust Racer backend for company
        counsel ;; Enhancements for ivy
        counsel-projectile ;; Counsel integration for projectile
        diff-hl ;; Show git changes in gutter
        diminish ;; Hide minor modes
        evil ;; VIM like keys
        evil-anzu ;; Show number of isearch candidates
        evil-commentary ;; Comment code out easily
        evil-surround ;; Manipulate braces/parenthesis/brackets...
        flx ;; Fuzzy sorting
        flycheck ;; Realtime syntax checking
        flycheck-irony ;; Irony backend for flycheck syntax checking
        flycheck-rust ;; Rustc backend for flycheck syntax checking
        flyspell-correct-ivy ;; Correct spelling with ivy menu
        gitconfig-mode ;; Syntax highlighting for gitconfig files.
        github-theme ;; Light theme
        gitignore-mode ;; Syntax highlighting for gitignore files.
        hl-anything ;; Highlight all things!
        hlinum ;; Highlight current line number
        irony ;; Clang based C/C++ code server
        irony-eldoc ;; Irony backend for documentation
        ivy ;; Completion framework
        ivy-rich ;; More rich frontends for ivy
        json-mode ;; Syntax highlighting and utilities for json
        key-chord ;; Map key chords to single function
        leuven-theme ;; Light theme
        log4j-mode ;; log4j syntax highlighting and utilies
        lua-mode ;; Syntax highlighting for lua
        magit ;; Emacs interface for git
        markdown-mode ;; Markdown syntax highlighting and utilies
        moe-theme ;; Light and Dark theme
        monokai-theme ;; Dark candy theme
        neotree ;; File tree
        nyan-mode ;; Nyan cat in modeline to show position of buffer
        org-pomodoro ;; Pomodoro technique in org mode
        projectile ;; Project navigation and management
        projectile-ripgrep ;; Run rg on project
        racer ;; Racer in Emacs
        ripgrep ;; rg in Emacs
        rust-mode ;; Rust syntax highlighting and formatting
        smex ;; Required for good sorting for Counsel-M-x
        sql-mode ;; SQL syntax highlighting
        swiper ;; ivy powered isearch
        syslog-mode ;; syslog syntax highlighting and utilities
        toml-mode ;; Syntax highlighting for TOML
        volatile-highlights ;; Highlight undo/redo affected areas
        which-key ;; Discover prefix keys
        yaml-mode ;; yaml syntax highlighting and utilities
        zenburn-theme ;; Dark theme
        zerodark-theme ;; Dark theme
	))

(defun my-install-packages ()
  "Refresh contents from melpa and install the necessary packages."
  (interactive)
  (package-refresh-contents)
  (package-install-selected-packages)
  )



;;; vim like keybindings
(require 'evil)
(evil-mode t)

;; jj to escape from insert mode
(require 'key-chord)
(key-chord-mode t)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

;; commenting
(require 'evil-commentary)
(evil-commentary-mode)

;; surrounding braces manipulation
(require 'evil-surround)
(global-evil-surround-mode t)

;; sorting
(define-key evil-normal-state-map (kbd "gs") 'evil-ex-sort)

;; scrolling with J, K
(define-key evil-normal-state-map (kbd "J") nil)
(define-key evil-motion-state-map (kbd "J") 'evil-scroll-down)
(define-key evil-normal-state-map (kbd "C-d") 'evil-join) ;; used to be on "J"
(define-key evil-normal-state-map (kbd "K") nil)
(define-key evil-motion-state-map (kbd "K") 'evil-scroll-up)

;; allow RET keybinding to bypass evil in motion state modes
(define-key evil-normal-state-map (kbd "RET") (lambda () (evil-next-line)))
(define-key evil-motion-state-map (kbd "RET") nil)

;; allow TAB to affect even in normal mode, TAB usually fixes indent
(define-key evil-normal-state-map (kbd "TAB") 'indent-for-tab-command)
(define-key evil-visual-state-map (kbd "TAB") 'indent-for-tab-command)

;; ivy powered searching
(require 'counsel-projectile)
(require 'projectile)
(require 'swiper)
(key-chord-define evil-motion-state-map "//" 'swiper) ;; search current buffer
(key-chord-define evil-motion-state-map "??" 'swiper-all) ;; search open buffers
(define-key evil-motion-state-map (kbd "g/") 'counsel-projectile-rg) ;; search in project
(define-key evil-motion-state-map (kbd "gp") 'projectile-command-map) ;; navigate buffers

;; error navigation
(define-key evil-normal-state-map (kbd "ge") 'flycheck-next-error)

;; extra
(define-key evil-motion-state-map (kbd "gr") 'revert-buffer)

;; use xref to find definitions
(define-key evil-motion-state-map (kbd "gd") 'xref-find-definitions)

;; projectile keys
(define-key projectile-mode-map (kbd "C-c p s") 'projectile-ripgrep)
(define-key projectile-mode-map (kbd "C-c c") 'projectile-compile-project)
(define-key projectile-mode-map (kbd "C-c r") 'projectile-run-project)
(define-key projectile-mode-map (kbd "C-c t") 'projectile-test-project)



;;; looks

;; light/dark themes

(require 'nyan-mode)
(setq nyan-bar-length 16)
(nyan-mode t)
(nyan-start-animation)
(nyan-toggle-wavy-trail)


(defun initialize-theme (&optional theme-name)
  "Initialize THEME-NAME defined theme."
  (interactive)
  (let ((th (or theme-name (getenv "EMACS_THEME"))))
    (cond
     ((string= th "apro-dark")
      (require 'apropospriate)
      (load-theme 'apropospriate-dark))
     ((string= th "apro-light")
      (require 'apropospriate)
      (load-theme 'apropospriate-light))
     ((string= th "leuven")
      (require 'leuven-theme)
      (load-theme 'leuven t))
     ((string= th "github")
      (require 'github-theme)
      (load-theme 'github t))
     ((string= th "moe-dark")
      (require 'moe-theme)
      (load-theme 'moe-dark))
     ((string= th "moe-light")
      (require 'moe-theme)
      (load-theme 'moe-light))
     ((string= th "monokai")
      (require 'monokai-theme)
      (load-theme 'monokai-theme))
     ((string= th "spacegray")
      (require 'spacegray-theme)
      (load-theme 'spacegray t))
     ((string= th "zenburn")
      (require 'zenburn-theme)
      (load-theme 'zenburn t))
     ((string= th "zerodark")
      (require 'zerodark-theme)
      (load-theme 'zerodark t)
      (zerodark-setup-modeline-format))
     (t))))

(initialize-theme)

;; font
(require 'all-the-icons)
(setq all-the-icons-scale-factor 1.0)
(custom-set-faces
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :height 144 :width normal)))))

;; remove screen clutter
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; lines
(require 'hlinum)
(global-linum-mode t) ;; show line numbers
(global-hl-line-mode t) ;; highlight current line
(hlinum-activate) ;; emphasize current line number
(column-number-mode) ;; show column number, as well as row number in modeline

;; show number of matches when searching a buffer
(require 'evil-anzu)
(global-anzu-mode)

;; highlight changes when using undo/redo functions
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; show keymap after pressing a prefix key
(require 'which-key)
(setq which-key-idle-delay 0.7)
(which-key-mode)

;; misc emacs
(add-to-list 'evil-motion-state-modes 'custom-mode)



;;; buffer/file formatting

;; disk and backups
(require 'autorevert)
(setq auto-revert-interval 3
      auto-save-file-name-transforms `((".*" "~/.saves/" t))
      auto-save-list-file-prefix "~/.saves/"
      backup-directory-alist '(("." . "~/.saves")))
(global-auto-revert-mode t)

;; formatting
(setq-default indent-tabs-mode nil
	      fill-column 80)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; parenthesis
(require 'hl-anything)
(add-hook 'prog-mode-hook 'hl-paren-mode)
(electric-pair-mode t)



;;; git integration

;; fix magit for evil
(require 'magit)
(setq auto-revert-check-vc-info t
      magit-commit-show-diff nil)
(add-to-list 'evil-motion-state-modes 'magit-diff-mode)
(add-to-list 'evil-motion-state-modes 'magit-status-mode)
(define-key magit-diff-mode-map (kbd "r") 'magit-refresh-all)
(define-key magit-status-mode-map (kbd "r") 'magit-refresh-all)

;; show info in gutter
(require 'diff-hl)
(require 'diff-hl-flydiff)
(setq diff-hl-flydiff-delay 1.0)
(global-diff-hl-mode t)
(diff-hl-flydiff-mode t)



;;; emacs/project management

;; projectile - project management
(require 'projectile)
(setq
 projectile-ignored-project-function
 (lambda (root)
   nil))
(projectile-mode t)

;; ivy + counsel - incremental completion
(require 'counsel)
(require 'ivy)
(require 'flx)
(require 'ivy-rich)
(require 'counsel-projectile)
(require 'smex)
(setq ivy-sort-max-size 30000
      ivy-flx-limit 10000
      ivy-height 24
      ivy-fixed-height-minibuffer t)
(ivy-mode)
(counsel-mode)
(ivy-toggle-fuzzy)
(counsel-projectile-on)
(ivy-set-display-transformer 'ivy-switch-buffer 'ivy-rich-switch-buffer-transformer)
(ivy-set-display-transformer 'counsel-projectile-switch-to-buffer 'ivy-rich-switch-buffer-transformer)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-c SPC") 'ivy-resume)

;; neotree - file tree interface
(require 'neotree)
(require 'projectile)
(setq neo-theme 'icons
      neo-smart-open t
      neo-show-hidden-files t
      neo-window-width 24
      neo-auto-indent-point nil)
(defun neotree-toggle-dwim ()
  "Similar to neotree-toggle but it is projectile aware.
Opens in the project root if in a projectile project."
  (interactive)
  (if (and (projectile-project-p) (not (neo-global--window-exists-p)))
      (neotree-projectile-action)
    (neotree-toggle)))
(add-to-list 'evil-motion-state-modes 'neotree-mode)
(add-hook 'neotree-mode-hook (lambda () (linum-mode -1)))
(global-set-key (kbd "<f10>") 'neotree-toggle-dwim)
(define-key neotree-mode-map (kbd "RET") 'neotree-enter-ace-window)



;;; misc
(setq mouse-autoselect-window t
      browse-url-browser-function 'browse-url-chromium)
(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f11>") (lambda () (interactive) (load-file "~/.emacs.d/init.el")))



;;; window management
(require 'ace-window)
(defun split-window-bsp (&optional window)
  "Split WINDOW either vertically or horizontally, whatever is best."
  (interactive)
  (let ((window (or window (selected-window)))
        (aspect-ratio 2.4)
        (w (window-body-width window))
        (h (window-body-height window)))
    (if (< (* h aspect-ratio) w)
        (with-selected-window window (split-window-horizontally))
      (with-selected-window window (split-window-vertically)))))
(setq split-window-preferred-function 'split-window-bsp
      aw-dispatch-always t
      aw-fair-aspect-ratio 2.4
      aw-scope 'frame
      window-min-width 24
      window-min-height 16)
(set-face-attribute 'aw-leading-char-face nil :height 8.0)
(global-set-key (kbd "C-c s") 'split-window-bsp)
(define-key evil-motion-state-map (kbd "gw") 'ace-window)
(define-key evil-normal-state-map (kbd "gw") nil)


;;; IDE features, auto-complete, code documentation, and syntax checking.

;; company - auto-completion
(require 'company)
(require 'company-flx)
(setq company-idle-delay 0.4
      company-minimum-prefix-length 2
      company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-tooltip-limit 20
      company-tooltip-minimum 20
      company-tooltip-minimum-width 60)
;; fuzzy matching and automatically show docs
(add-hook 'company-mode-hook 'company-flx-mode)
;; C-n and C-p selection
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
;; documentation
(define-key company-active-map (kbd "C-h") 'company-show-doc-buffer)
;; only tab(not enter) completes
(define-key company-active-map (kbd "RET") nil)
(define-key company-active-map [return] nil)
(define-key company-active-map [tab] 'company-complete-selection)
(define-key company-active-map (kbd "TAB") 'company-complete-selection)

;; eldoc - code documentation
(require 'eldoc)
(setq eldoc-echo-area-use-multiline-p t
      eldoc-idle-delay 0.3)


;; flycheck - syntax checking
(require 'flycheck)
(setq flycheck-checker-error-threshold 400
      flycheck-display-errors-delay 0.5
      flycheck-idle-change-delay 1.0)
(add-to-list 'evil-motion-state-modes 'flycheck-error-list-mode)

;; flyspell - spell checking
(require 'flyspell-correct-ivy)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(define-key flyspell-mode-map (kbd "C-c a") 'flyspell-correct-previous-word-generic)



;;; compilation mode - runs processes and shows output
(require 'ansi-color)
(add-to-list 'evil-motion-state-modes 'compilation-mode)
;; don't shadow evil's bindings
(setq comint-scroll-to-bottom-on-output t
      compilation-scroll-output 'first-error)
(define-key compilation-mode-map (kbd "g") nil)
(define-key compilation-mode-map (kbd "h") nil)
(define-key compilation-mode-map (kbd "r") 'revert-buffer)
(add-hook 'compilation-filter-hook
          (lambda () (let ((buffer-read-only nil))
                       (ansi-color-apply-on-region (point-min) (point-max)))))



;;; languages

;; C/C++
;;
;; automatically brings up an irony server to provide smart
;; functionality.
(require 'company-irony)
(require 'company-irony-c-headers)
(require 'flycheck-irony)
(require 'irony)
(require 'irony-eldoc)
(add-to-list 'company-backends 'company-irony)
(add-to-list 'company-backends 'company-irony-c-headers)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'flycheck-mode-hook 'flycheck-irony-setup)
(add-hook 'irony-mode-hook 'company-mode)
(add-hook 'irony-mode-hook 'irony-eldoc)
(add-hook 'irony-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook (lambda () (add-hook 'before-save-hook #'clang-format-buffer nil t)))

;; Clojure
;;
;; requires connection to a Clojure REPL with cider
(require 'cider)
(require 'clojure-mode)
(add-hook 'cider-mode-hook 'company-mode)
(add-hook 'cider-mode-hook 'eldoc-mode)
(add-hook 'cider-mode-hook 'flycheck-mode)

;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
            (define-key emacs-lisp-mode-map (kbd "C-c r") 'eval-buffer)))

;; Rust
;;
;; Uses racer as a backend for documentation and completions.
(require 'company-racer)
(require 'flycheck-rust)
(require 'racer)
(require 'rust-mode)
(setenv "RUST_SRC_PATH" (expand-file-name "~/src/rust/src"))
;; TODO: figure out why initial value of racer-rust-src-path is
;; correct, but then it switches to bogus value
(setq racer-rust-src-path nil)
(add-to-list 'exec-path "~/.cargo/bin")
(add-to-list 'company-backends 'company-racer)
(add-hook 'flycheck-mode-hook 'flycheck-rust-setup)
(add-hook 'rust-mode-hook 'rust-enable-format-on-save)
(add-hook 'rust-mode-hook 'flycheck-mode)
(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'racer-mode-hook 'company-mode)
(add-hook 'racer-mode-hook 'eldoc-mode)
(add-hook 'rust-mode-hook
	  (lambda ()
	    (setq-local fill-column 100)
            (setq-local projectile-tags-command "~/.cargo/bin/rusty-tags emacs")
	    (setq-local projectile-project-compilation-cmd "cargo build")
	    (setq-local projectile-project-run-cmd "cargo run")
	    (setq-local projectile-project-test-cmd "cargo test")))
(add-hook 'racer-mode-hook
	  (lambda ()
            (define-key evil-normal-state-map (kbd "gd") nil)
            (define-key evil-motion-state-map (kbd "gd") 'racer-find-definition)))


;; hide all minor modes
(require 'diminish)
(diminish 'anzu-mode)
(diminish 'auto-revert-mode)
(diminish 'company-mode)
(diminish 'counsel-mode)
(diminish 'eldoc-mode)
(diminish 'evil-commentary-mode)
(diminish 'evil-surround-mode)
(diminish 'flycheck-mode)
(diminish 'flyspell-mode)
(diminish 'irony-mode)
(diminish 'highlight-parentheses-mode)
(add-hook 'hl-paren-mode-hook (lambda () (diminish 'hl-paren-mode)))
(diminish 'ivy-mode)
(diminish 'racer-mode)
(diminish 'undo-tree-mode)
(diminish 'volatile-highlights-mode)
(diminish 'which-key-mode)

(provide 'init)
;;; init.el ends here
