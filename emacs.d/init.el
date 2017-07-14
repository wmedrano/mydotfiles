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
      '(
        cider ;; Clojure code introspection
        clojure-mode ;; Clojure
        company ;; Autocomplete
        company-racer ;; Autocomplete backend for Rust
        counsel ;; Ivy integration
        counsel-projectile ;; Counsel for projectile
        diff-hl ;; Highlight git differences
        diminish ;; Hide modeline
        evil ;; VIM keys
        evil-commentary ;; Comment out code
        evil-magit ;; Fix VIM keys for magit
        flycheck ;; Syntax checking
        flycheck-rust ;; Syntax checking backend for Rust
        flyspell ;; Spell checking
        ivy ;; Emacs completions
        key-chord ;; Bind functions to key chords
        leuven-theme ;; Light theme
        magit ;; git integration
        nyan-mode ;; Nyan cat in modeline
        projectile ;; Project management
        projectile-ripgrep ;; Search project with ripgrep
        rust-mode ;; Rust
        s ;; String utility library
        smex ;; Better M-x for counse-M-x
        smooth-scrolling ;; Smooth scrolling
        swiper ;; Search buffers for text
        volatile-highlights ;; Highlight undo
        which-key ;; Discover prefix keys
        zenburn-theme ;; Dark theme
	))

(defun my-install-packages ()
  "Refresh contents from melpa and install the necessary packages."
  (interactive)
  (package-refresh-contents)
  (package-install-selected-packages)
  )


;; theming
(require 'nyan-mode)
(defun light-theme ()
  "Enable the light theme."
  (interactive)
  (disable-theme 'zenburn)
  (load-theme 'leuven t))
(defun dark-theme ()
  "Enable the dark theme."
  (interactive)
  (disable-theme 'leuven)
  (load-theme 'zenburn t))
(setq inhibit-startup-screen t
      nyan-animate-nyancat t
      nyan-bar-length 10
      nyan-wavy-trail t)
(blink-cursor-mode -1)
(light-theme)
(menu-bar-mode -1)
(nyan-mode t)
(nyan-start-animation)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(custom-set-faces
 '(default ((t (:family "Fira Mono" :slant normal :width normal)))))


;; Misc
(require 'which-key)
(setq browse-url-browser-function 'browse-url-chrome)
(which-key-mode)


;; vim like keys
(require 'evil)
(require 'evil-commentary)
(require 'key-chord)
(evil-mode t)
(key-chord-mode t)
(evil-commentary-mode)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(define-key evil-normal-state-map (kbd "gs") 'evil-ex-sort)
(define-key evil-motion-state-map (kbd "J") 'evil-scroll-down)
(define-key evil-normal-state-map (kbd "J") nil)
(define-key evil-normal-state-map (kbd "C-d") 'evil-join)
(define-key evil-motion-state-map (kbd "K") 'evil-scroll-up)
(define-key evil-normal-state-map (kbd "K") nil)
(define-key evil-normal-state-map (kbd "TAB") 'indent-for-tab-command)
(define-key evil-visual-state-map (kbd "TAB") 'indent-for-tab-command)
(define-key evil-motion-state-map (kbd "q") 'quit-window)


;; undo
(require 'volatile-highlights)
(volatile-highlights-mode t)


;; file refresh
(require 'autorevert)
(setq auto-revert-interval 3
      auto-save-file-name-transforms `((".*" "~/.saves/" t))
      auto-save-list-file-prefix "~/.saves/"
      backup-directory-alist '(("." . "~/.saves")))
(global-auto-revert-mode t)
(define-key evil-normal-state-map (kbd "gr") 'revert-buffer)


;; buffer formatting
(require 'smooth-scrolling)
(setq-default indent-tabs-mode nil
	      fill-column 80
              smooth-scroll-margin 3)
(electric-pair-mode t)
(global-hl-line-mode t)
(global-linum-mode t)
(smooth-scrolling-mode t)


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


;; emacs/project management
(require 'counsel)
(require 'counsel-projectile)
(require 'ivy)
(require 'projectile)
(setq projectile-ignored-project-function (lambda (root)
   (or (string-match "/tmp/*" root)
       (string-match ".*\.cargo/*" root))))
(setq ivy-height 24
      ivy-fixed-height-minibuffer t
      ivy-wrap t)
(counsel-mode)
(ivy-mode)
(counsel-projectile-on)
(projectile-mode t)
(global-set-key (kbd "M-x") #'counsel-M-x)
(define-key evil-motion-state-map (kbd "gp") 'projectile-command-map)
(define-key evil-normal-state-map (kbd "gp") nil)
(define-key projectile-mode-map (kbd "C-c p s") 'projectile-ripgrep)


;; Window management
(require 'ace-window)
(setq aw-dispatch-always t
      aw-fair-aspect-ratio 2.35
      aw-scope 'frame
      window-min-width 12
      window-min-height 5)
(global-set-key (kbd "C-c w") 'ace-window)
(define-key evil-motion-state-map (kbd "gw") 'ace-window)
(define-key evil-normal-state-map (kbd "gw") nil)


;; Text search
(define-key evil-motion-state-map (kbd "g/") 'counsel-projectile-rg)
(define-key evil-normal-state-map (kbd "g/") nil)
(key-chord-define evil-motion-state-map (kbd "//") 'swiper)
(key-chord-define evil-motion-state-map (kbd "??") 'swiper-all)


;; Code documentation
(setq eldoc-echo-area-use-multiline-p t)


;; Autocompletion
(require 'company)
(setq company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-tooltip-limit 20
      company-tooltip-minimum 20
      company-tooltip-minimum-width 60)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") 'company-show-doc-buffer)
(define-key company-active-map (kbd "RET") nil)
(define-key company-active-map [return] nil)
(define-key company-active-map [tab] 'company-complete-selection)
(define-key company-active-map (kbd "TAB") 'company-complete-selection)


;; Syntax checking
(require 'flycheck)
(setq flycheck-check-syntax-automatically '(save mode-enabled))
(define-key evil-normal-state-map (kbd "ge") 'flycheck-next-error)


;; Spell checking
(require 'flyspell)
(require 'flyspell-correct)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'flyspell-mode-hook 'flyspell-buffer)
(global-set-key (kbd "C-c a") 'flyspell-correct-previous-word-generic)


;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)


;; Clojure
(add-hook 'cider-mode-hook 'company-mode)
(add-hook 'cider-mode-hook 'eldoc-mode)
(add-hook 'cider-mode-hook 'flycheck-mode)


;; Rust
(setenv "RUST_SRC_PATH" (expand-file-name "~/src/rust/src"))
;; TODO: figure out why initial value of racer-rust-src-path is correct, but
;; then it switches to bogus value
(setq-default racer-rust-src-path nil)
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


;; Hide modeline entries
(diminish 'auto-revert-mode)
(diminish 'evil-commentary-mode)
(diminish 'flyspell-mode)
(diminish 'helm-mode)
(diminish 'undo-tree-mode)
(diminish 'volatile-highlights-mode)
(diminish 'which-key-mode)


(provide 'init)
;;; init.el ends here
