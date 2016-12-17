;;; package --- init
;;; Commentary:
;;;     will.s.medrano@gmail.com Emacs configuration
;;;
;;;     evil mode, vim like keybindings
;;;
;;;     projectile for project awareness
;;;
;;;     helm + company autocomplete + flycheck syntax checker + eldoc code documentation
;;;
;;;     language specific back-ends for understanding code
;;; Code:


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4e753673a37c71b07e3026be75dc6af3efbac5ce335f3707b7d6a110ecb636a3" default)))
 '(helm-mode t)
 '(package-selected-packages
   (quote
    (helm-open-github persp-mode ace-jump-buffer flyspell-correct-helm ace-jump-mode evil-search-highlight-persist markdown-mode helm-company helm-ag helm-projectile helm auto-highlight-symbol rainbow-delimiters hlinum nyan-mode glsl-mode flycheck-rust volatile-highlights racer highlight-parentheses diff-hl evil-anzu anzu yaml-mode leuven-theme neotree toml-mode magit evil-commentary evil-surround zenburn-theme which-key smooth-scrolling lua-mode key-chord julia-shell irony-eldoc hindent flycheck-irony flycheck-haskell evil company-racer company-jedi company-irony-c-headers company-irony company-ghc cider ag ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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
;; This actually needs to be explicitly loaded by irony
(require 'cl-lib)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; path variables
;; add cargo just in case
;; my mac setup doesn't recognize brew packages by default
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; rust binaries installed with cargo
(setenv "PATH" (concat (getenv "PATH") "~/.cargo/bin"))
(add-to-list 'exec-path "~/.cargo/bin")

;; brew path for mac
(when (eq system-type 'darwin)
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; project managing and global emacs environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'projectile)

(setq projectile-mode-line '(:eval
                             (if (file-remote-p default-directory) " Proj[]"
                               (format " Proj[%s]" (projectile-project-name))))
      )
(defalias 'yes-or-no-p 'y-or-n-p) ;; yes/no prompts now accept y/n
(projectile-mode t) ;; enable projectile for project recognition
(add-to-list 'projectile-globally-ignored-directories ".cargo") ;; ignore .cargo directories

;; helm
(require 'helm)
(require 'helm-projectile)
(setq helm-always-two-windows t)
(add-to-list 'display-buffer-alist
	     `(,(rx bos "*helm" (* not-newline) "*" eos)
	       (display-buffer-in-side-window)
	       (inhibit-same-window . t)
	       (window-height . 0.4)
               ))
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(defun custom-keyboard-quit ()
  "`custom-keyboard-quit' is similar to the default `keyboard-quit'.
It clears other things as well."
  (interactive)
  (evil-search-highlight-persist-remove-all)
  (keyboard-quit)
  )
(global-set-key (kbd "C-g") 'custom-keyboard-quit)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vim + global keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; initialize evil mode
(require 'evil)
(require 'evil-commentary)
(require 'evil-surround)
(evil-mode t) ;; enable evil mode globally
(evil-commentary-mode t) ;; enable commenting out code in vim like way
(global-evil-surround-mode t) ;; parens/brace manipulation

;; navigation keys
(require 'key-chord)
(key-chord-mode t) ;; enable binding to fast consecutive keypresses for bindings
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state) ;; jj to go from insert state to normal state
;; I use J and K to scroll, instead of C-d, C-u
(define-key evil-normal-state-map (kbd "J") nil)
(define-key evil-motion-state-map (kbd "J") 'evil-scroll-down)
(define-key evil-normal-state-map (kbd "C-d") 'evil-join) ;; used to be on "J"
(define-key evil-normal-state-map (kbd "K") nil)
(define-key evil-motion-state-map (kbd "K") 'evil-scroll-up)
;; Sometimes pressing enter in non-editing files should do something, like open a file
(define-key evil-motion-state-map (kbd "RET") nil) ;; remove shadowing of ret key

;; manual-automatic indentation, make tab indent the line, selected region
(define-key evil-normal-state-map (kbd "TAB") 'indent-for-tab-command)
(define-key evil-visual-state-map (kbd "TAB") 'indent-for-tab-command)

;; non-editing modes
(add-to-list 'evil-motion-state-modes 'magit-diff-mode) ;; diffing in git
(add-to-list 'evil-motion-state-modes 'neotree-mode) ;; file tree navigation
(add-to-list 'evil-motion-state-modes 'flycheck-error-list-mode) ;; lists buffer errors
(add-to-list 'evil-motion-state-modes 'messages-buffer-mode) ;; lists Emacs errors
(add-to-list 'evil-motion-state-modes 'cider-stacktrace-mode) ;; clojure errors

;; non-vim modes
(add-to-list 'evil-emacs-state-modes 'comint-mode) ;; interpreter
(add-to-list 'evil-emacs-state-modes 'image-mode) ;; image viewer

;; g keys, g is a prefix key in evil normal/motion/visual state maps,
;; which makes it convenient to add in useful functionality under it
(require 'ace-jump-mode)
(require 'ace-window)
(require 'helm-projectile)
(set-face-font 'aw-leading-char-face "inconsolata-128")
(define-key evil-motion-state-map (kbd "g e") 'flycheck-next-error) ;; go to next error
;; opens a frame that lists buffer errors
(define-key evil-motion-state-map (kbd "g E") 'flycheck-list-errors)
(define-key evil-motion-state-map (kbd "g l") 'ace-jump-line-mode)
(define-key evil-motion-state-map (kbd "g p") 'helm-projectile) ;; open buffer/file/project
(define-key evil-motion-state-map (kbd "g P") 'helm-projectile-switch-project) ;; open project
(define-key evil-motion-state-map (kbd "g r") 'revert-buffer) ;; revert buffer to its file contents or rerun command
(define-key evil-motion-state-map (kbd "g w") 'ace-window)
(define-key evil-normal-state-map (kbd "g w") nil) ;;
(define-key evil-motion-state-map (kbd "g /") 'helm-projectile-ag) ;; search all buffers

;; Emacs defines a prefix keymap under C-c
(require 'ace-jump-mode)
(require 'ace-window)
(require 'flyspell-correct-helm)
(require 'projectile)
;; projectile keys, they are under the global keymap to make them easily override-able
(global-set-key (kbd "C-c a") 'flyspell-correct-previous-word-generic)
(global-set-key (kbd "C-c b") 'projectile-compile-project)
(global-set-key (kbd "C-c j") 'ace-jump-mode)
(global-set-key (kbd "C-c r") 'projectile-run-project)
(global-set-key (kbd "C-c t") 'projectile-test-project)
;; manage windows, monolithic function
;; see documentation for ace-window for functionality
(global-set-key (kbd "C-c w") 'ace-window)

;; fXX keys
(defun reload-emacs-config ()
  "Reload init.el."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f11>") 'reload-emacs-config)
(global-set-key (kbd "<f10>") 'neotree-toggle)
(global-set-key [(shift f10)] 'neotree-projectile-action)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; theming and looks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; color scheme, mode-line and font
(defun small-font ()
  "Set the font for low res displays."
  (interactive)
  (set-face-font 'default "inconsolata-12"))

(defun big-font ()
  "Set the font for hi dpi displays."
  (interactive)
  (set-face-font 'default "inconsolata-14"))

(defun load-light-theme ()
  "Load the light theme."
  (interactive)
  (require 'leuven-theme)
  (load-theme 'leuven t))

(defun load-dark-theme ()
  "Load the dark theme."
  (interactive)
  (require 'zenburn-theme)
  (load-theme 'zenburn t))

(big-font)
(load-light-theme)


;; toolbars and scrollbars
(require 'nyan-mode)
(require 'smooth-scrolling)
(setq
 nyan-bar-length 16 ;; make the nyan scroll bar 16 characters wide
 smooth-scroll-margin 3) ;; when scrolling above/below page, only scroll n, lines
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(nyan-mode t)
(nyan-start-animation)
(nyan-toggle-wavy-trail)
(smooth-scrolling-mode t) ;; enable using the smooth-scroll-margin

;; line numbers, emphasis and details
(require 'diff-hl)
(require 'diff-hl-flydiff)
(require 'hlinum)
(setq
 ;; show column number in modeline
 column-number-mode t
 ;; wait for t sesconds of inactivity to update git status for lines
 diff-hl-flydiff-delay 1.0)
(global-linum-mode t) ;; show line numbers
(hlinum-activate) ;; bold the current line number
(global-hl-line-mode t) ;; highlight current line
(global-diff-hl-mode t) ;; show git changes on the left fringes, doesn't work in terminals
(diff-hl-flydiff-mode t) ;; calculate the diffs on the fly, don't wait for saving

;; parenthesis
(require 'paren)
(require 'highlight-parentheses)
(setq show-paren-delay 1.0 ;; highlight matching parenthesis after t seconds
      hl-paren-delay 0.4 ;; wait a little bit before bolding (actually reddening) outer parens
      )
(show-paren-mode t) ;; highlight matching parens when on a paren
(global-highlight-parentheses-mode t) ;; highlight (actually makes red) outer parens
(electric-pair-mode t) ;; create matching closing parens/braces automatically

;; misc
(require 'auto-highlight-symbol)
(require 'evil-anzu)
(require 'evil-search-highlight-persist)
(require 'volatile-highlights)
(require 'which-key)
(setq inhibit-startup-screen t ;; stop showing annoying welcome screen
      which-key-idle-delay 0.2 ;; wait t seconds before showing which key info
      ahs-idle-interval 1.0 ;; highlight current symbol in buffer after t seconds of idle
      mouse-autoselect-window t ;; allow mouse to fuzzy focus
      )
(set-face-background 'vhl/default-face "IndianRed1") ;; make undo/redo highighting red
(set-face-background 'ahs-face "yellow1") ;; make symbol highlighting yellow
(global-auto-highlight-symbol-mode t) ;; highlight symbols at point
(global-anzu-mode t) ;; show number of matches for isearch/evil-search
(global-evil-search-highlight-persist t) ;; persist search highlighting
(volatile-highlights-mode t) ;; highlight affected areas when using undo/redo
(which-key-mode t) ;; enable which key, shows keybinding help after pressing a prefixed key


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; file formatting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-save-default nil ;; don't autosave, (# files)
      backup-inhibited t ;; don't backup, (~ files)
      make-backup-files nil ;; no backups
      fill-column 80 ;; M-q(command-fill-paragraph) will aim for 80 characters per line
      indent-tabs-mode nil ;; don't use tabs
      )
(global-auto-revert-mode t) ;; update emacs buffers when files change for whatever reason
(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; trim whitespace before saving

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general code inspection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auto completion
(require 'company)
(require 'helm-company)
(setq company-idle-delay 0.5 ;; start autocompleting after t seconds
      company-minimum-prefix-length 2 ;; start completing after second character
      company-selection-wrap-around t ;; make selection back wrappeable
      company-tooltip-align-annotations t ;; show annotations
      company-tooltip-limit 20 ;; show n candidates in view
      company-tooltip-minimum 20 ;; show n candidates in view?
      company-tooltip-minimum-width 60) ;; make n characters wide
(global-company-mode t) ;; enable auto-completion globally
(add-hook 'company-mode-hook
          (lambda ()
            (define-key company-mode-map (kbd "C-c SPC") 'helm-company) ;; use helm to find completions
            (define-key company-active-map (kbd "C-n") 'company-select-next) ;; C-n to go to next candidate
            (define-key company-active-map (kbd "C-p") 'company-select-previous) ;; C-p to go to previous candidate
            (define-key company-active-map (kbd "C-h") 'company-show-doc-buffer) ;; Show documentation for selected entry
            ;; Make tab only way to complete. There are 2 entries for each since company defines both of them as well
            (define-key company-active-map (kbd "RET") nil) ;; Make return not do anything, will insert new line
            (define-key company-active-map [return] nil) ;; Make return not do anything, will insert new line
            (define-key company-active-map [tab] 'company-complete-selection) ;; use tab to complete
            (define-key company-active-map (kbd "TAB") 'company-complete-selection) ;; use tab to complete
            ))


;; syntax/spell checking
(require 'flycheck)
(require 'flyspell)
(setq flycheck-checker-error-threshold 400 ;; don't show more than 400 errors
      flycheck-display-errors-delay 10.0 ;; Wait t seconds of idle before displaying errors in minibuffer
      ;; This is higher than eldoc's delay to make flycheck take precedence.
      flycheck-idle-change-delay 1.5) ;; wait 1.0 seconds of idle before finding new errors
(global-flycheck-mode t) ;; enable flycheck in all buffers
(add-hook 'text-mode-hook 'flyspell-mode) ;; enable spell checking in text modes
(add-hook 'prog-mode-hook 'flyspell-prog-mode) ;; spellcheck comments in program modes
(add-to-list 'special-display-buffer-names "*Flycheck errors*") ;; give it its own frame

;; code documentation - display docs in echo area

(require 'eldoc)
(setq eldoc-echo-area-use-multiline-p t ;; allow eldoc to resize minibuffer
      eldoc-idle-delay 0.2 ;; Show faster than flycheck to allow flycheck to take precedence.
      )
(global-eldoc-mode t) ;; enable eldoc in all modes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; major-mode/language specific
;; things are added as hooks for lazy loading, which decreases Emacs startup
;; time.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; compilation
(defun set-up-compilation ()
  "Set up Emacs for compilation.
Compilation isn't necessarily compilation, it can run any command."
  (interactive)
  (require 'compile)
  ;; reuse the same compilation buffer
  (define-key compilation-mode-map (kbd "r") 'revert-buffer) ;; reruns the compilation
  (define-key compilation-mode-map (kbd "h") nil) ;; should still be hjkl
  ;; by default reruns compilation, but let this still be the vim prefix key, g
  (define-key compilation-mode-map (kbd "g") nil)
  )

 ;; open compilation buffers in their own frame
(add-to-list 'special-display-buffer-names "*compilation*")
(add-hook 'compilation-mode-hook 'set-up-compilation)

;; c/c++/obj-c
;; irony creates a C++ server with clang tools for analyzing c/c++/obj-c code.
(defun set-up-irony-mode ()
  "Set up irony mode.  Irony mode interacts with a clang server to analyze code."
  (require 'company)
  (require 'company-irony)
  (require 'company-irony-c-headers)
  (require 'evil)
  (require 'flycheck-irony)
  (require 'irony)
  (require 'irony-eldoc)
  (add-to-list 'company-backends '(company-irony-c-headers company-irony)) ;; add irony backend for autocompleting
  (flycheck-irony-setup) ;; set up flycheck to use irony
  (irony-cdb-autosetup-compile-options) ;; ???
  (irony-eldoc) ;; allow eldoc to get information from irony
  (define-key evil-normal-state-map (kbd "C-c b") 'cc-compile))
(add-hook 'irony-mode-hook 'set-up-irony-mode)
(add-hook 'c++-mode-hook 'irony-mode) ;; enable irony for c++
(add-hook 'c-mode-hook 'irony-mode) ;; enable irony for c
(add-hook 'objc-mode-hook 'irony-mode) ;; enable irony for objc

;; clojure language
(defun set-up-clojure-lang ()
  "Setup for clojure-mode."
  (interactive)
  (require 'cider)
  (require 'clojure-mode)
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
  "Set up for 'emacs-lisp-mode'."
  (define-key emacs-lisp-mode-map (kbd "C-c b") 'byte-compile-file)
  (define-key emacs-lisp-mode-map (kbd "C-c r") 'eval-buffer)) ;; run code in buffer
(add-hook 'emacs-lisp-mode-hook 'set-up-emacs-lisp-lang)

;; haskell language - not tested very much
(defun set-up-haskell-lang ()
  "Set up for 'haskell-mode'.
Warning untested, and I don't know what the right packages to use are."
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
(add-to-list 'special-display-buffer-names "*cider-error*")

;; julia language
(defun set-up-julia-lang ()
  "Set up for 'julia-mode'."
  (interactive)
  (require 'julia-mode)
  (require 'julia-shell)
  (define-key julia-mode-map (kbd "C-c b") 'run-julia) ;; start julia repl
  (define-key julia-mode-map (kbd "C-c r") 'julia-shell-save-and-go) ;; run buffer
  )
(add-hook 'julia-mode-hook 'set-up-julia-lang)

;; lua language
(defun set-up-lua-lang ()
  "Setup for 'lua-mode'."
  (interactive)
  (require 'lua-mode)
  (setq lua-indent-level 4)) ;; set lua indentation to 4 spaces
(add-hook 'lua-mode-hook 'set-up-lua-lang)

;; rust language
(defun set-up-rust-lang ()
  "Setup for rust-mode."
  (interactive)
  (require 'company)
  (require 'company-racer)
  (require 'compile)
  (require 'racer)
  ;; enable racer mode, Rust AutoCompletER
  ;; provides completion and documentation info
  (racer-mode t)
  (make-local-variable 'projectile-project-compilation-cmd)
  (make-local-variable 'projectile-project-run-cmd)
  (make-local-variable 'projectile-project-test-cmd)
  (setq
   projectile-project-compilation-cmd "cargo build"
   projectile-project-test-cmd "cargo test"
   projectile-project-run-cmd "cargo run"
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
  (make-local-variable 'before-save-hook)
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
  (define-key evil-normal-state-map (kbd "g d") 'jedi:goto-definition) ;; jedi definition
  )

(add-hook 'python-mode-hook 'set-up-python-lang)

;; sql language
(defun set-up-sql-lang ()
  "Setup for `sql-mode'."
  (interactive))

(add-hook 'sql-mode-hook 'set-up-sql-lang)



(provide 'init)
;;; init.el ends here
