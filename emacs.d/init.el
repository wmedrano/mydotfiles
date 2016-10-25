;;; package --- init
;;; Commentary:
;;;     will.s.medrano@gmail.com Emacs configuration
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
    (counsel-projectile counsel ivy hl-todo magit evil-commentary evil-surround zenburn-theme which-key smooth-scrolling smart-mode-line lua-mode key-chord julia-shell irony-eldoc ibuffer-projectile hindent go-eldoc git-gutter git-gutter+ flyspell-popup flycheck-irony flycheck-haskell evil diminish company-racer company-jedi company-irony-c-headers company-irony company-go company-ghc cider cargo ag ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "PfEd" :slant normal :weight normal :height 113 :width normal)))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; global emacs
(defun global-emacs-setup ()
  "Setup for things consistent across all of Emacs."
  (interactive)
  ;; misc
  (require 'diminish)
  (require 'smooth-scrolling)
  (setq auto-save-default nil
	make-backup-files nil
	column-number-mode t
	major-mode 'org-mode
	mouse-autoselect-window t
	global-auto-revert-mode t
	inhibit-startup-screen t
	smooth-scroll-margin 3)
  (smooth-scrolling-mode t)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (defalias 'yes-or-no-p 'y-or-n-p)
  ;; space formatting
  (setq fill-column 80
        indent-tabs-mode nil)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  ;; parens
  (setq show-paren-delay 0.0)
  (electric-pair-mode t)
  (show-paren-mode t)
  ;; lines
  (require 'git-gutter)
  (global-hl-line-mode t)
  (global-git-gutter-mode t)
  (diminish 'git-gutter-mode)
  ;; mode line
  (require 'smart-mode-line)
  (setq sml/name-width 32
	sml/no-confirm-load-theme t
	sml/theme 'dark)
  (sml/setup)
  ;; projectile + ivy + counsel
  (require 'diminish)
  (require 'ivy)
  (require 'counsel)
  (require 'projectile)
  (require 'counsel-projectile)
  (setq ivy-height 20
	projectile-completion-system 'ivy)
  (add-to-list 'projectile-globally-ignored-directories ".cargo")
  (projectile-cleanup-known-projects)
  (projectile-global-mode t)
  (ivy-mode t)
  (counsel-mode t)
  (counsel-projectile-on)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "C-h f") 'counsel-describe-function)
  (global-set-key (kbd "C-h v") 'counsel-describe-variable)
  (define-key projectile-mode-map (kbd "C-c p") nil) ;; packages shouldn't take C-c _
  (diminish 'ivy-mode)
  ;; ibuffer
  (require 'ibuffer)
  (require 'ibuffer-projectile)
  (global-set-key (kbd "C-x C-b") #'ibuffer)
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-projectile-set-filter-groups)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))
  ;; which-key
  (require 'which-key)
  (setq which-key-idle-delay 0.1
	which-key-lighter nil)
  (which-key-mode t))
(global-emacs-setup)

;; git and magit
(add-hook 'magit-diff-mode-hook
	  (lambda ()
	    (require 'evil)
	    (evil-motion-state)))

;; all languages
(require 'evil)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(add-hook 'prog-mode-hook 'flycheck-mode)
(add-hook 'prog-mode-hook 'eldoc-mode)
(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'prog-mode-hook 'evil-local-mode)
(add-hook 'text-mode-hook 'evil-local-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

;; c/c++/obj-c
(defun irony-mode-setup ()
  (require 'irony)
  (require 'company-irony)
  (require 'company-irony-c-headers)
  (require 'flycheck-irony)
  (require 'irony-eldoc)
  (require 'company)
  (add-to-list 'company-backends '(company-irony-c-headers company-irony))
  (flycheck-irony-setup)
  (irony-cdb-autosetup-compile-options)
  (irony-eldoc))
(add-hook 'irony-mode-hook 'irony-mode-setup)
(add-hook 'c++-mode-hook #'irony-mode)
(add-hook 'c-mode-hook #'irony-mode)
(add-hook 'objc-mode-hook #'irony-mode)

;; clojure language
(defun clojure-lang-setup ()
  "Setup for clojure-mode."
  (interactive)
  (require 'cider))
(add-hook 'clojure-mode-hook 'clojure-lang-setup)

;; elisp language
(defun emacs-lisp-lang-setup ()
  "Setup for emacs-lisp-mode.")
(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-lang-setup)

;; go language
(defun go-lang-setup ()
  (require 'go-mode)
  (require 'company-go)
  (require 'go-eldoc)
  (require 'company)
  (add-to-list 'company-backends 'company-go)
  (go-eldoc-setup)
  (add-hook 'before-save-hook 'gofmt-before-save))
(add-hook 'go-mode-hook 'go-lang-setup)

;; haskell language
(defun haskell-lang-setup ()
  (require 'haskell-mode)
  (require 'company-ghc)
  (require 'flycheck-haskell)
  (require 'company)
  (require 'ghc)
  (require 'hindent)
  (add-to-list 'company-backends 'company-ghc)
  (autoload 'ghc-init "ghc" nil t)
  (autoload 'ghc-debug "ghc" nil t)
  (flycheck-haskell-setup)
  (hindent-mode t)
  (ghc-init))
(add-hook 'haskell-mode-hook 'haskell-lang-setup)

;; julia language
(defun julia-lang-setup ()
  "Setup for `julia-mode`"
  (interactive)
  (require 'julia-mode)
  (require 'julia-shell)
  (define-key julia-mode-map (kbd "C-c C-c") #'julia-shell-save-and-go)
  (define-key julia-mode-map (kbd "C-c C-p") #'run-julia)
  (define-key julia-mode-map (kbd "C-c C-r") #'julia-shell-run-region-or-line))
(add-hook 'julia-mode-hook 'julia-lang-setup)

;; lua language
(defun lua-lang-setup ()
  "Setup for `lua-mode`"
  (interactive)
  (require 'lua-mode)
  (setq lua-indent-level 4))
(add-hook 'lua-mode-hook 'lua-lang-setup)

;; rust language
(defun rust-lang-setup ()
  "Setup for rust-mode."
  (interactive)
  (require 'company)
  (require 'company-racer)
  (require 'racer)
  (cargo-minor-mode t)
  (racer-mode t)
  (setq racer-cmd "~/.cargo/bin/racer"
	racer-rust-src-path "/usr/src/rust/src")
  (add-to-list 'company-backends 'company-racer)
  (flycheck-rust-setup)
  (define-key racer-mode-map (kbd "C-c C-d") 'racer-find-definition)
  (define-key cargo-minor-mode-map (kbd "C-c C-k") 'cargo-process-build)
  (define-key cargo-minor-mode-map (kbd "C-c C-r") 'cargo-process-run)
  (add-hook 'before-save-hook 'rust-format-buffer)
  )
(add-hook 'rust-mode-hook 'rust-lang-setup)

;; python language
(defun python-lang-setup ()
  "Setup for `python-mode`."
  (interactive)
  (require 'evil)
  (require 'company-jedi)
  (setq python-shell-interpreter "ipython")
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'python-lang-setup)

(defun sql-lang-setup ()
  "Setup for `sql-mode'."
  (interactive))
(add-hook 'sql-mode-hook 'sql-lang-setup)

;; vim like keybindings
(defun evil-keys-insert ()
  "Set bindings for evil insert state."
  (require 'key-chord)
  (key-chord-mode t)
  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state))

(defun evil-keys-normal ()
  "Set bindings for evil normal state."
  (require 'evil)
  (require 'swiper)
  (define-key evil-normal-state-map (kbd "J") 'evil-scroll-down)
  (define-key evil-normal-state-map (kbd "K") 'evil-scroll-up)
  (define-key evil-normal-state-map (kbd "C-d") 'evil-join)
  (define-key evil-normal-state-map (kbd "/") 'swiper)
  ;; swiper reverses the semantics of searching forwards and backwards
  ;; apparently
  (define-key evil-normal-state-map (kbd "n") 'evil-search-previous)
  (define-key evil-motion-state-map (kbd "n") 'evil-search-previous)
  (define-key evil-normal-state-map (kbd "N") 'evil-search-next)
  (define-key evil-motion-state-map (kbd "N") 'evil-search-next)
  ;; sacred g keys
  (require 'ace-window)
  (require 'counsel-projectile)
  (define-key evil-normal-state-map (kbd "g p") 'counsel-projectile)
  (define-key evil-normal-state-map (kbd "g t") 'load-theme)
  (define-key evil-normal-state-map (kbd "g w") 'ace-window)
  (define-key evil-normal-state-map (kbd "g /") 'counsel-projectile-ag))

(defun evil-keys-setup ()
  "Setup for evil-mode, vim-like keybindings."
  (interactive)
  (require 'diminish)
  (require 'evil)
  (require 'evil-surround)
  (evil-keys-insert)
  (evil-keys-normal)
  (evil-commentary-mode t)
  (evil-surround-mode t)
  (diminish 'evil-surround-mode)
  (diminish 'evil-commentary-mode))
(add-hook 'evil-local-mode-hook 'evil-keys-setup)

;; auto-complete
(defun company-autocomplete-setup ()
  "Setup for company-mode, auto-completion."
  (require 'company)
  (require 'counsel)
  (require 'diminish)
  (setq company-lighter nil
	company-idle-delay 0.1
	company-minimum-prefix-length 1
	company-selection-wrap-around t
	company-tooltip-align-annotations t
	company-tooltip-limit 24
	company-tooltip-minimum 24
	company-tooltip-minimum-width 64)
  (define-key company-mode-map (kbd "C-c c") 'counsel-company)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-h") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map [return] nil)
  (define-key company-active-map [tab] 'company-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  )
(add-hook 'company-mode-hook 'company-autocomplete-setup)

;; syntax/spell check
(defun flycheck-syntax-checker-setup ()
  "Setup for flycheck-mode, syntax checking."
  (interactive)
  (require 'flycheck)
  (setq flycheck-checker-error-threshold 800
	flycheck-display-errors-delay 0.1
	flycheck-idle-change-delay 1.0)
  )
(defun flyspell-spell-checker-setup ()
  "Setup for flyspell-mode, spell checking."
  (interactive)
  (require 'flyspell)
  (setq flyspell-mode-line-string nil))
(add-hook 'flycheck-mode-hook 'flycheck-syntax-checker-setup)
(add-hook 'flyspell-mode-hook 'flyspell-spell-checker-setup)


;; documentation - display docs in echo area
(defun eldoc-setup ()
  "Setup for `eldoc-mode`."
  (interactive)
  (require 'diminish)
  (require 'eldoc)
  (setq eldoc-echo-area-use-multiline-p t
	eldoc-idle-delay 0.05
	eldoc-echo-area-use-multiline-p t)
  (diminish 'eldoc-mode))
(add-hook 'eldoc-mode-hook 'eldoc-setup)

;; undo-tree mode is started by evil
(add-hook 'undo-tree-mode-hook (lambda ()
				 (setq undo-tree-mode-lighter nil)))

(provide 'init)
;;; init.el ends here
