;;; wmedrano-emacs --- Summary:
;;;   Good support for C/C++, Clojure, Emacs Lisp, and Rust.
;;;   Includes auto completions, documentation lookup, and syntax checking.
;;;   Uses evil for VIM like keys bindings.
;;; Commentary:
;;;   wmedrano@gmail.com
;;; Code:

;;; Stop emacs from automatically modifying this file
(setq custom-file "/dev/null")

;;; package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages
      '(
	ace-window ;; window jumping
	ag ;; required by projectile-ag
	all-the-icons ;; icons
	cider ;; Clojure REPL support
	clojure-mode ;; Clojure syntax
	company ;; Autocompletions
	company-flx ;; Allow fuzzy autocompletions
	company-irony ;; Irony backend for company
	company-irony-c-headers ;; Irony headers for autocompletion
	company-racer ;; Rust Racer backend for company
	counsel ;; Ivy optimized functions, (M-x, find-file, describe-variable...)
        company-quickhelp ;; Show documentation for selected candidate in company
	counsel-projectile ;; Ivy optimized projectile function and realtime project ag
	diff-hl ;; Show git changes in gutter
	evil ;; VIM like keys
	evil-commentary ;; Comment code out easily
	evil-surround ;; Manipulate braces/parenthesis/brackets...
	flycheck ;; Realtime syntax checking
	flycheck-irony ;; Irony backend for flycheck syntax checking
	flycheck-rust ;; Rustc backend for flycheck syntax checking
	flyspell-correct-ivy ;; Correct spelling with ivy menu
	hlinum ;; Highlight current line number
	irony ;; Clang based C/C++ code server
	irony-eldoc ;; Irony backend for documentation
	ivy ;; Completion frontend
	json-mode ;; Syntax highlighting and utilities for json
	lua-mode ;; Syntax highlighting for lua
	key-chord ;; Map key chords to single function
	leuven-theme ;; Light theme
	log4j-mode ;; log4j syntax highlighting and utilies
	nyan-mode ;; Nyan cat in modeline to show position of buffer
	magit ;; Emacs interface for git
	markdown-mode ;; Markdown syntax highlighting and utilies
	neotree ;; File tree
	projectile ;; Project navigation and management
	racer ;; Racer in Emacs
	rust-mode ;; Rust syntax highlighting and formatting
        pos-tip ;; used by company-quickhelp, melpa version has more bugfixes
	sql-mode ;; SQL syntax highlighting
	swiper ;; Better isearch
	syslog-mode ;; syslog syntax highlighting and utilities
	volatile-highlights ;; Highlight undo/redo affected areas
	which-key ;; Discover prefix keys
	yaml-mode ;; yaml syntax highlighting and utilities
	zerodark-theme ;; Dark theme
	))

(defun my-install-packages ()
  "Refresh contents from melpa and install the necessary packages."
  (interactive)
  (package-refresh-contents)
  (package-install-selected-packages)
  ;; install irony, c++ server
  ;; requires cmake and clang
  (require 'irony)
  (irony-install-server)
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

;; swiper + counsel-projectile-ag for searching
(require 'swiper)
(require 'counsel-projectile)
(define-key evil-motion-state-map (kbd "/") 'swiper) ;; search in buffer
(define-key evil-motion-state-map (kbd "g/") 'counsel-projectile-ag) ;; search in project
(define-key evil-motion-state-map (kbd "gp") 'counsel-projectile) ;; navigate buffers

;; window navigation
(define-key evil-normal-state-map (kbd "gw") nil)
(define-key evil-motion-state-map (kbd "gw") 'ace-window)

;; error navigation
(define-key evil-normal-state-map (kbd "ge") 'flycheck-next-error)

;; projectile keys
(define-key projectile-mode-map (kbd "C-c c") 'projectile-compile-project)
(define-key projectile-mode-map (kbd "C-c r") 'projectile-run-project)
(define-key projectile-mode-map (kbd "C-c t") 'projectile-test-project)



;;; looks

;; light/dark themes
(defun load-dark-theme ()
  "Use the zerodark theme along with its stylish modeline."
  (require 'zerodark-theme)
  (load-theme 'zerodark t)
  (zerodark-setup-modeline-format))

;; TODO: refactor mode line modification into melpa package.
(require 'flycheck)
(defun flycheck-modeline-status-icon ()
  "Return the status of flycheck to be displayed in the mode-line."
  (when flycheck-mode
    (let* ((text (pcase flycheck-last-status-change
                   (`finished (if flycheck-current-errors
                                  (let ((count (let-alist (flycheck-count-errors flycheck-current-errors)
                                                 (+ (or .warning 0) (or .error 0)))))
                                    (propertize (format "✖ %s Issue%s" count (if (eq 1 count) "" "s"))
                                                'face '(:height 0.9 :foreground "red")))
                                (propertize "✔ No Issues"
                                            'face '(:height 0.9 :foreground "green"))))
                   (`running     (propertize "⟲ Running"
                                             'face '(:height 0.9 :foreground "yellow")))
                   (`no-checker  (propertize "⚠ No Checker"
                                             'face '(:height 0.9 :foreground "orange")))
                   (`not-checked "✖ Disabled"
                                 'face '(:height 0.9 :foreground "orange"))
                   (`errored     (propertize "⚠ Error"
                                             'face '(:height 0.9 :foreground "red")))
                   (`interrupted (propertize "⛔ Interrupted"
                                             'face '(:height 0.9 :foreground "orange")))
                   (`suspicious  ""))))
      (propertize text
                  'help-echo "Show Flycheck Errors"
                  'local-map (make-mode-line-mouse-map
                              'mouse-1 #'flycheck-list-errors)))))

(require 'nyan-mode)
(defun load-light-theme ()
  "Use the leuven theme."
  (require 'leuven-theme)
  (setq nyan-bar-length 16)
  (load-theme 'leuven t)
  (nyan-mode)
  (nyan-toggle-wavy-trail)
  (nyan-start-animation)
  (setq-default mode-line-format
		`("%e"
		  mode-line-front-space
		  mode-line-mule-info
		  mode-line-client
		  mode-line-remote

		  ;;; modified
		  (:eval (if (buffer-modified-p (current-buffer))
			     (all-the-icons-faicon "floppy-o"
						   :height 0.9
						   :v-adjust 0)
			   (all-the-icons-faicon "check"
						 :height 0.9
						 :v-adjust 0)))

		  mode-line-frame-identification
		  mode-line-buffer-identification
		  "   "
		  mode-line-position

		  ;;; flycheck status
		  (:eval (flycheck-modeline-status-icon))

		  ;;; version control
		  (vc-mode ("  "
			    (:eval (all-the-icons-faicon "code-fork"
							 :height 0.9
							 :v-adjust 0
							 :face '(:foreground "green")))
			    (:eval (propertize
				    (truncate-string-to-width vc-mode 25 nil nil "...")
				    'face '(:foreground "green")))))
		  "  "

                  ;;; evil status
		  evil-mode-line-tag

		  ;;; modes
		  mode-line-modes mode-line-misc-info mode-line-end-spaces)
		)
  )

(if (string= (getenv "COLOR_SCHEME") "dark")
	(load-dark-theme)
	(load-light-theme))

;; font
(require 'all-the-icons)
(setq all-the-icons-scale-factor 1.0)
(set-frame-font "ubuntu mono 14")

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

;; highlight changes when using undo/redo functions
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; show keymap after pressing a prefix key
(require 'which-key)
(setq which-key-idle-delay 1.0)
(which-key-mode)



;;; buffer/file formatting

;; disk and backups
(setq backup-directory-alist '(("." . "~/.saves")))
(global-auto-revert-mode t)

;; formatting
(setq fill-column 80
      indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; parenthesis
(electric-pair-mode t)



;;; git integration

;; fix magit for evil
(require 'magit)
(add-to-list 'evil-motion-state-modes 'magit-diff-mode)

;; show info in gutter
(require 'diff-hl)
(require 'diff-hl-flydiff)
(setq diff-hl-flydiff-delay 1.0)
(global-diff-hl-mode t)
(diff-hl-flydiff-mode t)



;;; emacs/project management

;; ivy - completion frontend
(require 'ivy)
(setq ivy-height 16
      ivy-wrap t
      ivy-flx-limit 1000)
(ivy-mode t)

;; projectile - project management
(require 'projectile)
(setq projectile-completion-system 'ivy)
(setq
 projectile-ignored-project-function
 (lambda (root)
   nil))
(projectile-mode t)

;; counsel - ivy optimized functionality
(require 'counsel)
(require 'counsel-projectile)
(setq counsel-mode-override-describe-bindings t)
(counsel-mode t)
(counsel-projectile-on)

;; neotree - file tree interface
(require 'neotree)
(require 'projectile)
(setq neo-theme 'icons
      neo-smart-open t
      neo-show-hidden-files t
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



;; use ripgrep instead of ag - not ready yet
;; (add-to-list 'exec-path "~/.cargo/bin")
;; (require 'counsel)
;; (setq counsel-ag-base-command "rg --with-filename --no-heading --color=never -n %s")



;;; IDE features, auto-complete, code documentation, and syntax checking.

;; company - auto-completion
(require 'company)
(require 'company-flx)
(require 'company-quickhelp)
(setq company-idle-delay 0.4
      company-minimum-prefix-length 2
      company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-tooltip-limit 20
      company-tooltip-minimum 20
      company-tooltip-minimum-width 60)
;; fuzzy matching and automatically show docs
(add-hook 'company-mode-hook 'company-flx-mode)
(add-hook 'company-mode-hook 'company-quickhelp-mode)
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



;;; misc
(setq mouse-autoselect-window t)
(defalias 'yes-or-no-p 'y-or-n-p)



;;; compilation mode - runs processes and shows output
(add-to-list 'evil-motion-state-modes 'compilation-mode)
;; don't shadow evil's bindings
(define-key compilation-mode-map (kbd "g") nil) ;; revert
(define-key compilation-mode-map (kbd "h") nil) ;; help
(define-key compilation-mode-map (kbd "r") 'revert-buffer)



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
            (define-key projectile-mode-map (kbd "C-c r") nil)
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
	    (setq-local projectile-project-compilation-cmd "cargo build")
	    (setq-local projectile-project-run-cmd "cargo run")
	    (setq-local projectile-project-test-cmd "cargo test")))
(add-hook 'racer-mode-hook
	  (lambda ()
	    (define-key evil-normal-state-map (kbd "gd") nil)
	    (define-key evil-motion-state-map (kbd "gd") 'racer-find-definition)))



(provide 'init)
;;; init.el ends here
