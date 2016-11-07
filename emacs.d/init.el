;;; package --- init
;;; Commentary:
;;;     will.s.medrano@gmail.com Emacs configuration
;;;     evil mode, vim keybindings
;;;     counsel mode, better autocompletions
;;;     company + flycheck + eldoc
;;;     rust + clojure + haskell + julia + python + c/c++/objc + lua
;;; Code:


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4e753673a37c71b07e3026be75dc6af3efbac5ce335f3707b7d6a110ecb636a3" default)))
 '(package-selected-packages
   (quote
    (glsl-mode flyspell-correct-popup flycheck-rust volatile-highlights racer highlight-parentheses diff-hl evil-anzu anzu yaml-mode leuven-theme neotree toml-mode counsel-projectile counsel ivy magit evil-commentary evil-surround zenburn-theme which-key smooth-scrolling lua-mode key-chord julia-shell irony-eldoc hindent go-eldoc flyspell-popup flycheck-irony flycheck-haskell evil diminish company-racer company-jedi company-irony-c-headers company-irony company-go company-ghc cider ag ace-window)))
 '(volatile-highlights-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "PfEd" :slant normal :weight normal :height 98 :width normal))))
 '(ahs-face ((t (:background "goldenrod1"))))
 '(vhl/default-face ((t (:background "IndianRed1" :foreground "black" :underline nil)))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(defun my-install-packages ()
  "Refresh contents from melpa and install the necessary packages."
  (interactive)
  (package-refresh-contents)
  (package-install-selected-packages)
  (require 'irony)
  (message "Installing irony server for C/C++/ObjC integration.")
  (irony-install-server)
  (message "Installing jedi for Python integration.")
  (require 'company-jedi)
  (jedi:install-server))

;; (require 'dash) ;; library for common functional programming fns
;; (require 's) ;; basic string manipulation library
;; clisp functions and macros
;; This actually needs to be explicitly loaded by some packages
;; (irony)
(require 'cl)

;; vim like keybindings
(defun set-up-evil-keys-insert ()
  "Set bindings for evil insert state."
  (require 'evil)
  (require 'key-chord)
  (key-chord-mode t) ;; enable binding to fast consecutive keypresses
  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)) ;; jj to go back to normal mode

(defun set-up-evil-keys-normal ()
  "Set bindings for evil normal state. It is mostly a superset of the evil motion state."
  (require 'ace-window)
  (require 'counsel-projectile)
  (require 'evil)
  ;; replace evil-join with scrolling down
  (define-key evil-normal-state-map (kbd "J") 'evil-scroll-down)
  ;; scroll up
  (define-key evil-normal-state-map (kbd "K") 'evil-scroll-up)
  ;; replace scroll down with join
  (define-key evil-normal-state-map (kbd "C-d") 'evil-join)
  ;; overwrite motion state behavior, which let the return fall through to the buffer
  (define-key evil-normal-state-map (kbd "RET") 'indent-for-tab-command)
  ;; sacred g keys
  (define-key evil-normal-state-map (kbd "g e") 'flycheck-next-error)
  ;; replace evil-fill
  (define-key evil-normal-state-map (kbd "g w") 'ace-window))

(defun set-up-evil-keys-visual ()
  "Set bindings for evil visual state mode."
  (define-key evil-visual-state-map (kbd "RET") 'indent-for-tab-command))

(defun set-up-evil-motion-keys ()
  "Set bindings for evil motion state."
  (require 'ace-window)
  (require 'counsel-projectile)
  (require 'evil)
  (define-key evil-motion-state-map (kbd "J") 'evil-scroll-down) ;; scroll down
  (define-key evil-motion-state-map (kbd "K") 'evil-scroll-up) ;; scroll up
  ;; remove RET binding, some buffers go somewhere when RET is pressed, but evil overrides this binding
  (define-key evil-motion-state-map (kbd "RET") nil) ;; don't do anything
  ;; sacred g keys
  (define-key evil-motion-state-map (kbd "g P") 'counsel-projectile-switch-project) ;; switch project or open file in project
  (define-key evil-motion-state-map (kbd "g p") 'counsel-projectile) ;; switch project or open file in project
  ;; move to another window, enumerated if there are more than 2
  (define-key evil-motion-state-map (kbd "g w") 'ace-window)
  (define-key evil-motion-state-map (kbd "g /") 'counsel-projectile-ag)) ;; search entire project using ag

(defun set-up-evil-keys ()
  "Setup for evil-mode, vim-like keybindings."
  (interactive)
  (require 'diminish)
  (require 'evil)
  (require 'evil-commentary)
  (require 'evil-surround)
  (evil-mode t) ;; enable evil mode globally
  ;; set up keys for different states
  (set-up-evil-keys-insert) ;; defined above
  (set-up-evil-keys-normal) ;; defined above
  (set-up-evil-keys-visual) ;; defined above
  (set-up-evil-motion-keys) ;; defined above
  (evil-commentary-mode t) ;; "g c" to comment out code, ie: gcc for lines, gcw for word..., or v-select stuff-gc
  (evil-surround-mode t) ;; parenthesis stuff, I haven't figured it out how to use it yet
  ;; modes that don't use regular evil modes
  ;; emacs-state - regular emacs, no vim stuff
  (add-to-list 'evil-emacs-state-modes 'comint-mode)
  ;; motion-state - just movement, no editing
  (add-to-list 'evil-motion-state-modes 'magit-diff-mode)
  (add-to-list 'evil-motion-state-modes 'neotree-mode)
  (add-to-list 'evil-motion-state-modes 'flycheck-error-list-mode)
  (add-to-list 'evil-motion-state-modes 'compilation-mode)
  (add-to-list 'evil-motion-state-modes 'messages-buffer-mode)
  (diminish 'evil-surround-mode) ;; don't show in modeline
  (diminish 'evil-commentary-mode)) ;; don't show in modeline

(defun set-up-ide-base-keys ()
  "Add basic functions to key map such as build, run, and
  test. These are really basic and better overwritten by
  project/language specific bindings."
  (interactive)
  (require 'projectile)
  ;; Set the default build run and test commands
  (global-set-key (kbd "C-c b") 'projectile-compile-project)
  (global-set-key (kbd "C-c r") 'projectile-run-project)
  (global-set-key (kbd "C-c t") 'projectile-test-project)
  ;; Add extra ignore directories for rust
  (add-to-list 'projectile-globally-ignored-directories ".cargo"))

(add-hook 'after-init-hook 'set-up-evil-keys)
(add-hook 'projectile-mode-hook 'set-up-ide-base-keys)

;; global keys
(defun reload-emacs-config ()
  "Reload init.el."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(defun set-up-global-keys ()
  "Set up global key bindings."
  (interactive)
  (require 'neotree)
  (global-set-key (kbd "<f11>") 'reload-emacs-config) ;;
  (global-set-key (kbd "<f10>") 'neotree-toggle)) ;; file tree

(add-hook 'after-init-hook 'set-up-global-keys)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; theming and looks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun set-up-styling ()
    "Set up emacs styling."
  (interactive)
  (require 'diff-hl)
  (require 'evil-anzu)
  (require 'diminish)
  (require 'smooth-scrolling)
  (require 'volatile-highlights)
  (require 'which-key)
  (setq column-number-mode t ;; display the column number in mode line
	inhibit-startup-screen t ;; stop showing annoying welcome screen
	smooth-scroll-margin 3 ;; .. scroll margin 3
        which-key-idle-delay 0.1 ;; wait 0.1 seconds before showing which key info
	diff-hl-flydiff-delay 0.1 ;; wait for 0.1 seconds of idle time to update git status
	ahs-idle-interval 0.2 ;; highlight symbols
	)
  (global-anzu-mode t) ;; show number of matches for isearch/evil-search
  (diminish 'anzu-mode) ;; don't waste space in modeline with "Anzu"
  (global-linum-mode t) ;; show line numbers
  (global-hl-line-mode t) ;; highlight current
  (smooth-scrolling-mode t) ;; enable smooth scroll
  (menu-bar-mode -1) ;; hide menu bar
  (tool-bar-mode -1) ;; and hide toolbar
  (scroll-bar-mode -1) ;; don't show scroll bar
  (global-diff-hl-mode t) ;; show git changes on the left fringes, doesn't work in terminals
  (diff-hl-flydiff-mode t) ;; calculate diffs on the fly, don't wait for saving
  (volatile-highlights-mode t) ;; highlight affected areas when using undo/redo
  (diminish 'volatile-highlights-mode) ;; but don't show in modeline
  ;; don't waste mode line space showing "git gutter"
  (which-key-mode t) ;; enable which key, shows keybinding help after pressing a prefixed key
  (diminish 'which-key-mode) ;; don't waste modeline space displaying wkey
  (load-theme 'leuven t) ;; light theme
  )

(add-hook 'after-init-hook 'set-up-styling)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; file formatting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun set-up-file-formatting ()
  "Set up file formatting."
  (interactive)
  (setq auto-save-default nil ;; extraneous files annoy me
	backup-inhibited t ;; extraneous files annoy me
	make-backup-files nil ;; extraneous files annoy me
	fill-column 80 ;; M-q(command-fill-paragraph) will aim for 80 characters per line
	indent-tabs-mode nil ;; don't use tabs
        )
  (global-auto-revert-mode t) ;; update emacs buffers when files change for whatever reason
  (add-hook 'before-save-hook 'delete-trailing-whitespace) ;; trim before saving
  )
(add-hook 'after-init-hook 'set-up-file-formatting)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; path variables
;; add cargo just in case
;; my mac setup doesn't recognize brew packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fix-paths ()
  "Fix paths for mac and brew."
  (interactive)
  ;; rust binaries installed with cargo
  (setenv "PATH" (concat (getenv "PATH") "~/.cargo/bin"))
  (add-to-list 'exec-path "~/.cargo/bin")
  ;; brew path for mac
  (when (eq system-type 'darwin)
    (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
    (setq exec-path (append exec-path '("/usr/local/bin")))))
(add-hook 'after-init-hook 'fix-paths)

;; parenthesis
(defun set-up-parenthesis ()
  "Set up parenthesis."
  (interactive)
  (setq show-paren-delay 0.0 ;; highlight parenthesis right away
	hl-paren-delay 0.05
        )
  (show-paren-mode t) ;; highlight matching parens when on paren
  (global-highlight-parentheses-mode t) ;; highlight (makes red) outer parens
  (diminish 'highlight-parentheses-mode) ;; don't show hl-p in the modeline
  (electric-pair-mode t) ;; create matching closing parens/braces automatically
  )

(add-hook 'after-init-hook 'set-up-parenthesis)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; better minibuffer completions to everything, find-file, M-x, ag
;; ivy provides the completion backend
;; counsel versions use ivy and add more info to completion items
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun set-up-minibuffer-completions ()
  "Set up minibuffer compeltions."
  (interactive)
  (require 'counsel)
  (require 'diminish)
  (require 'ivy)
  (setq ivy-height 32 ;; max height to 32 entries
	ivy-use-virtual-buffers t ;; allow ivy history
	ivy-format-function 'ivy-format-function-line ;; highlight whole line for selection in ivy
	)
  (ivy-mode t) ;; allow ivy to replace default
  (diminish 'ivy-mode) ;; don't waste modeline space displaying ivy
  (counsel-mode t) ;; replace some functions with counsel versions
                   ;; ie: m-x, c-x c-f, c-h f
  (diminish 'counsel-mode) ;; don't waste modeline space displaying counsel
  )

(add-hook 'after-init-hook 'set-up-minibuffer-completions)


;; misc
(defun set-up-misc-stuff ()
  "Set up stuff other stuff."
  (interactive)
  (setq mouse-autoselect-window t ;; mouse can set focus on emacs windows
        )
  (defalias 'yes-or-no-p 'y-or-n-p)) ;; yes/no prompts now accept y/n

(add-hook 'after-init-hook 'set-up-misc-stuff)


;; auto-complete
(defun set-up-company-mode ()
  "Setup for company-mode, auto-completion."
  (require 'company)
  (require 'counsel)
  (require 'diminish)
  (setq company-idle-delay 0.15 ;; start autocompleting after 0.15 seconds
	company-minimum-prefix-length 2 ;; start completing after second character
	company-selection-wrap-around t ;; make selection back wrappeable
	company-tooltip-align-annotations t ;; show annotations
	company-tooltip-limit 24 ;; show 24 candidates in view
	company-tooltip-minimum 24 ;; show 24 candidates in view?
	company-tooltip-minimum-width 64) ;; make 64 characters wide
  (define-key company-mode-map (kbd "C-c SPC") 'counsel-company) ;; use counsel to find completions
  (define-key company-active-map (kbd "C-n") 'company-select-next) ;; C-n to go to next candidate
  (define-key company-active-map (kbd "C-p") 'company-select-previous) ;; C-p to go to previous candidate
  (define-key company-active-map (kbd "C-h") 'company-show-doc-buffer) ;; Show documentation for selected entry
  ;; Make tab only way to complete. There are 2 entries for each since company defines both of them as well
  (define-key company-active-map (kbd "RET") nil) ;; Make return not do anything, will insert new line
  (define-key company-active-map [return] nil) ;; Make return not do anything, will insert new line
  (define-key company-active-map [tab] 'company-complete-selection) ;; use tab to complete
  (define-key company-active-map (kbd "TAB") 'company-complete-selection) ;; use tab to complete
  (diminish 'company-mode) ;; don't waste modeline space displaying Comp
  )

(add-hook 'company-mode-hook 'set-up-company-mode)

(add-hook 'prog-mode-hook 'company-mode) ;; enable autocompletion in all modes


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; project awareness
;; enables functions like counsel-projectile-ag
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun set-up-project-awareness ()
  "make emacs aware of projects using projectile."
  (interactive)
  (require 'projectile)
  (require 'counsel-projectile)
  (setq projectile-ignored-projects '("/usr/src/rust/"))
  (projectile-global-mode t) ;; enable projectile
  (projectile-cleanup-known-projects) ;; delete projects that don't exist from cache
  (counsel-projectile-on) ;; enable counsel for projectile, for the find file
  )

(add-hook 'after-init-hook 'set-up-project-awareness)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; syntax/spell checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun set-up-flycheck-syntax-checker ()
  "Setup for flycheck-mode, syntax checking."
  (interactive)
  (require 'flycheck)
  (setq flycheck-checker-error-threshold 400 ;; don't show more than 400 errors
	flycheck-display-errors-delay 0.1 ;; Wait 0.1 seconds of idle before displaying errors in minibuffer.
	                                  ;; This is higher than eldoc's delay to make flycheck take precedence.
	flycheck-idle-change-delay 1.0) ;; wait 1.0 seconds of idle before finding new errors
  )

(defun set-up-flyspell-spell-checker ()
  "Setup for flyspell-mode, spell checking."
  (interactive)
  (require 'diminish)
  (require 'flyspell)
  (diminish 'flyspell-mode) ;; don't waste modeline space
  (diminish 'flyspell-prog-mode)) ;; don't waste modeline space

(add-hook 'flycheck-mode-hook 'set-up-flycheck-syntax-checker)
(add-hook 'flyspell-mode-hook 'set-up-flyspell-spell-checker)
(add-hook 'text-mode-hook 'flyspell-mode) ;; enable spell checking in text modes
(add-hook 'prog-mode-hook 'flyspell-prog-mode) ;; spellcheck comments in program modes
(global-flycheck-mode t) ;; enable syntax checking in all programming languages


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; code documentation - display docs in echo area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun set-up-eldoc ()
  "Setup for `eldoc-mode`."
  (interactive)
  (require 'eldoc)
  (setq eldoc-echo-area-use-multiline-p t ;; allow eldoc to resize minibuffer
	eldoc-idle-delay 0.05 ;; Show faster than flycheck to allow flycheck to take precedence.
	))

(add-hook 'eldoc-mode-hook 'set-up-eldoc)
(add-hook 'prog-mode-hook 'eldoc-mode) ;; enable eldoc in all modes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; compilation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun set-up-compilation ()
  "Sets up emacs for compilation. Compilation isn't necessarily
compilation, it can run any command."
  (interactive)
  (require 'compile)
  ;; reuse the same compilation buffer
  (define-key compilation-mode-map (kbd "r") 'revert-buffer) ;; reruns the compilation
  ;; by default reruns compilation, but let this still be a vim key
  (define-key compilation-mode-map (kbd "g") nil)
  )

(add-to-list 'special-display-buffer-names "*compilation*")
(add-hook 'compilation-mode-hook 'set-up-compilation)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; language specific
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; c/c++/obj-c
;; irony creates a C++ server with clang tools for analyzing C++ code.
(defun set-up-irony-mode ()
  (require 'irony)
  (require 'company-irony)
  (require 'company-irony-c-headers)
  (require 'evil)
  (require 'flycheck-irony)
  (require 'irony-eldoc)
  (require 'company)
  (add-to-list 'company-backends '(company-irony-c-headers company-irony)) ;; add irony backend for autocompleting
  (flycheck-irony-setup) ;; set up flycheck to use irony
  (irony-cdb-autosetup-compile-options) ;; ???
  (irony-eldoc)
  (define-key evil-normal-state-mode (kbd "C-c b") 'cc-compile)) ;; allow eldoc to get information from irony

(add-hook 'irony-mode-hook 'set-up-irony-mode)
(add-hook 'c++-mode-hook 'irony-mode) ;; enable irony for c++
(add-hook 'c-mode-hook 'irony-mode) ;; enable irony for c
(add-hook 'objc-mode-hook 'irony-mode) ;; enable irony for objc

;; clojure language
(defun set-up-clojure-lang ()
  "Setup for clojure-mode."
  (interactive)
  (require 'cider)
  (require 'clojure)
  (require 'rainbow-delimiters)
  ;; connect to lein repl
  ;; I usually create a lein repl outside of emacs
  ;; Either way, I end up doing 2 cider connects, 1 for clojure and 1 for clojurescript
  (define-key clojure-mode-map (kbd "C-c b") 'cider-connect) ;; connect to lein repl
  (define-key clojure-mode-map (kbd "C-c r") 'cider-load-buffer) ;; run code in buffer
  )

(add-hook 'clojure-mode-hook 'set-up-clojure-lang)

;; elisp language
(defun set-up-emacs-lisp-lang ()
  "Setup for emacs-lisp-mode."
  (define-key emacs-lisp-mode-map (kbd "C-c b") 'byte-compile-file)
  (define-key emacs-lisp-mode-map (kbd "C-c r") 'eval-buffer)) ;; run code in buffer

(add-hook 'emacs-lisp-mode-hook 'set-up-emacs-lisp-lang)

;; go language - untested
(defun set-up-go-lang ()
  (require 'go-mode)
  (require 'company-go)
  (require 'go-eldoc)
  (require 'company)
  (add-to-list 'company-backends 'company-go) ;; use company go backed for auto completion
  (go-eldoc-setup) ;; set up eldoc for go
  (add-hook 'before-save-hook 'gofmt-before-save)) ;; use gofmt on all go files
(add-hook 'go-mode-hook 'set-up-go-lang)

;; haskell language - not tested very much
(defun set-up-haskell-lang ()
  (require 'haskell-mode)
  (require 'company-ghc)
  (require 'flycheck-haskell)
  (require 'company)
  (require 'ghc)
  (require 'hindent)
  (add-to-list 'company-backends 'company-ghc) ;; use ghc backend for autocompletion
  (autoload 'ghc-init "ghc" nil t) ;; init ghc
  (autoload 'ghc-debug "ghc" nil t) ;; init ghc debug
  (flycheck-haskell-setup) ;; extra flycheck setup needed
  (hindent-mode t) ;; enable HaskellINDENT
  (ghc-init)) ;; initialize ghc
(add-hook 'haskell-mode-hook 'set-up-haskell-lang)

;; julia language
(defun set-up-julia-lang ()
  "Setup for `julia-mode`"
  (interactive)
  (require 'julia-mode)
  (require 'julia-shell)
  (define-key julia-mode-map (kbd "C-c b") 'run-julia) ;; start julia repl
  (define-key julia-mode-map (kbd "C-c r") 'julia-shell-save-and-go) ;; run buffer
  )

(add-hook 'julia-mode-hook 'set-up-julia-lang)

;; lua language
(defun set-up-lua-lang ()
  "Setup for `lua-mode`"
  (interactive)
  (require 'lua-mode)
  (setq lua-indent-level 4)) ;; set lua indentation to 4 spaces

(add-hook 'lua-mode-hook 'set-up-lua-lang)

;; rust language
(defun cargo-build ()
  "Run cargo build."
  (interactive)
  (compile "cargo build"))

(defun cargo-run ()
  "Run cargo run."
  (interactive)
  (compile "cargo run"))

(defun cargo-test ()
  "Run cargo test."
  (interactive)
  (compile "cargo test"))

(defun set-up-rust-lang ()
  "Setup for rust-mode."
  (interactive)
  (require 'company)
  (require 'company-racer)
  (require 'compile)
  (require 'racer)
  (racer-mode t) ;; enable racer mode, Rust AutoCompletER
  (diminish 'racer-mode) ;; but don't show in modeline, as rust implies racer
  (setq
   ;; Cargo commands are well defined, they don't need text refinement
   compilation-read-command nil
   ;; set rust src dir, varies between my linux and mac
   company-racer-rust-src (if (eq system-type 'darwin)
			      "~/github/rust/src"
			    "/usr/src/rust/src")
   racer-rust-src-path (if (eq system-type 'darwin)
			   "~/github/rust/src"
			 "/usr/src/rust/src"))
  (add-to-list 'company-backends 'company-racer) ;; add racer backend for completion
  (flycheck-rust-setup) ;; flycheck needs extra set up for rust, for cargo awareness probably
  (define-key evil-normal-state-map (kbd "g d") 'racer-find-definition) ;; replace evil's version with this
  (define-key rust-mode-map (kbd "C-c b") 'cargo-build) ;; cargo build
  (define-key rust-mode-map (kbd "C-c r") 'cargo-process-run) ;; cargo run
  (define-key rust-mode-map (kbd "C-c t") 'cargo-proces-test) ;; cargo test
  (add-hook 'before-save-hook 'rust-format-buffer) ;; use rust format before saving
  )

(add-hook 'rust-mode-hook 'set-up-rust-lang)

;; python language
(defun set-up-python-lang ()
  "Setup for `python-mode`."
  (interactive)
  (require 'evil)
  (require 'company-jedi)
  (require 'python)
  ;; TODO(wmedrano): fix ipython, spits out garbage characters
  ;; (setq python-shell-interpreter "python") ;; use ipython instead of python
  (add-to-list 'company-backends 'company-jedi) ;; use jedi backend for python completion
  (define-key python-mode-map (kbd "C-c b") 'run-python) ;; run a python shell
  (define-key python-mode-map (kbd "C-c r") 'python-shell-send-buffer) ;; run python buffer
  )

(add-hook 'python-mode-hook 'set-up-python-lang)

;; sql language
(defun set-up-sql-lang ()
  "Setup for `sql-mode'."
  (interactive))

(add-hook 'sql-mode-hook 'set-up-sql-lang)

;; undo-tree mode is started by evil
;; it allows navigation of undo history with a graphic tree
(defun set-up-undo-tree-mode ()
  "Setup for undo tree mode."
  (interactive)
  (require 'diminish)
  (diminish 'undo-tree-mode) ;; don't waste space in modeline displaying UTree
  )

(add-hook 'undo-tree-mode-hook 'set-up-undo-tree-mode)

(provide 'init)
;;; init.el ends here
