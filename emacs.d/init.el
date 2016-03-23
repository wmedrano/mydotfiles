;;; package --- init
;;; Commentary:
;;;     My Emacs configuration
;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(eldoc-echo-area-use-multiline-p t)
 '(package-selected-packages
   (quote
    (avy solarized-theme toml-mode julia-shell julia-mode undo-tree markdown-mode yafolding zenburn-theme dracula-theme flycheck-clojure eldoc-eval smart-mode-line powerline helm-mode-manager gitconfig-mode gitignore-mode powerline neotree benchmark-init company-jedi lua-mode flycheck-haskell company-ghc ghc hindent haskell-mode flyspell-popup go-eldoc company-go cider flycheck-irony irony-eldoc company-irony-c-headers company-irony helm-ag which-key yasnippet ibuffer-projectile anzu helm-projectile helm projectile magit flycheck-rust cargo company-racer racer rust-mode flycheck company monokai-theme)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "unknown" :slant normal :weight normal :height 113 :width normal)))))

(setq indent-tabs-mode nil
      inhibit-startup-screen t
      make-backup-files nil
      mouse-autoselect-window t)
(global-auto-revert-mode)
(column-number-mode +1)
(defalias 'yes-or-no-p 'y-or-n-p)
(electric-pair-mode +1)
(global-hl-line-mode)
(menu-bar-mode -1)
(set-fill-column 80)
(tool-bar-mode -1)
(xterm-mouse-mode +1)
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'prog-mode-hook #'auto-fill-mode)
(add-hook 'auto-fill-mode-hook (lambda () (set-fill-column 80)))

(require 'package)
(add-to-list 'package-archives '("marmalade"
                                 . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(defun my-install-packages ()
  "Refresh package archive and install packages."
  (interactive)
  (package-refresh-contents)
  (package-install-selected-packages))

(require 'anzu)
(require 'linum)
(require 'smart-mode-line)
(require 'undo-tree)
(require 'which-key)
(setq anzu-mode-lighter nil
      linum-format "%d "
      sml/name-width 24
      sml/theme 'respectful
      undo-tree-mode-lighter " ut"
      which-key-idle-delay 0.5
      which-key-lighter nil)
(load-theme 'monokai t)
(global-anzu-mode +1)
(global-linum-mode +1)
(global-undo-tree-mode +1)
(sml/setup)
(which-key-mode +1)

;; code folding
(require 'yafolding)
(add-hook 'prog-mode-hook #'yafolding-mode)

;; code documentation
(require 'eldoc)
(setq  eldoc-echo-area-use-multiline-p t
       eldoc-idle-delay 0.1)
(global-eldoc-mode +1)
(eldoc-in-minibuffer-mode +1)

;; auto completions and templates
(require 'company)
(require 'yasnippet)
(setq company-lighter " comp"
      company-idle-delay 0.05
      company-minimum-prefix-length 1
      company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-tooltip-limit 24
      company-tooltip-minimum 24
      company-tooltip-minimum-width 64)
(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets/")
(define-key company-mode-map (kbd "C-c c") #'company-complete)
(define-key yas-minor-mode-map (kbd "C-c y") #'company-yasnippet)
(define-key company-active-map [return] nil)
(define-key company-active-map (kbd "RET") nil)
(define-key company-active-map (kbd "TAB") #'company-complete-selection)
(define-key company-active-map [tab] #'company-complete-selection)
(global-company-mode +1)
(yas-global-mode +1)

;; syntax/spell checking
(require 'flycheck)
(require 'flyspell)
(setq flycheck-checker-error-threshold 800
      flycheck-display-errors-delay 0.2
      flycheck-idle-change-delay 1.0
      flyspell-mode-line-string " FlyS")
(define-key flyspell-mode-map (kbd "C-c a") #'flyspell-popup-correct)
(global-flycheck-mode +1)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)
(add-hook 'text-mode-hook #'flyspell-mode)

;; emacs completions and project
(require 'helm)
(require 'helm-mode)
(require 'neotree)
(require 'projectile)
(require 'helm-projectile)
(setq helm-completion-mode-string nil
      projectile-completion-system 'helm)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-c e") #'eshell)
(global-set-key (kbd "C-c n") #'neotree-toggle)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(define-key projectile-command-map (kbd "n") #'neotree-projectile-action)
(define-key projectile-command-map (kbd "s") #'helm-projectile-ag)
(helm-mode +1)
(projectile-global-mode)

;; git
(require 'magit)
(define-prefix-command 'magit-command-map)
(global-set-key (kbd "C-c g") #'magit-command-map)
(define-key magit-command-map (kbd "b") #'magit-branch)
(define-key magit-command-map (kbd "c") #'magit-commit)
(define-key magit-command-map (kbd "d") #'magit-diff)
(define-key magit-command-map (kbd "g") #'magit-pull)
(define-key magit-command-map (kbd "p") #'magit-push)
(define-key magit-command-map (kbd "s") #'magit-status)

;; buffer menu
(require 'ibuffer)
(require 'ibuffer-projectile)
(global-set-key (kbd "C-x C-b") #'ibuffer)
(add-hook 'ibuffer-hook
	  (lambda ()
	    (ibuffer-projectile-set-filter-groups)
	    (unless (eq ibuffer-sorting-mode 'alphabetic)
	      (ibuffer-do-sort-by-alphabetic))))

;; c/c++/obj-c
(require 'irony)
(require 'company-irony)
(require 'company-irony-c-headers)
(require 'flycheck-irony)
(require 'irony-eldoc)
(with-eval-after-load 'company
  (add-to-list 'company-backends '(company-irony-c-headers company-irony)))
(add-hook 'c++-mode-hook #'irony-mode)
(add-hook 'c-mode-hook #'irony-mode)
(add-hook 'objc-mode-hook #'irony-mode)
(add-hook 'irony-mode-hook #'flycheck-irony-setup)
(add-hook 'irony-mode-hook #'irony-cdb-autosetup-compile-options)
(add-hook 'irony-mode-hook #'irony-eldoc)

;; clojure language
(require 'cider)
(require 'flycheck-clojure)
(add-hook 'clojure-mode-hook #'flycheck-clojure-setup)

;; go language
(require 'go-mode)
(require 'company-go)
(require 'go-eldoc)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-go))
(add-hook 'go-mode-hook #'go-eldoc-setup)

;; Emacs lisp language

;; Haskell language
(require 'haskell-mode)
(require 'company-ghc)
(require 'flycheck-haskell)
(require 'ghc)
(require 'hindent)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-ghc))
(add-hook 'haskell-mode-hook #'hindent-mode)
(add-hook 'haskell-mode-hook #'ghc-init)
(add-hook 'haskell-mode-hook #'flycheck-haskell-setup)
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)

;; julia language
(require 'julia-mode)
(require 'julia-shell)
(define-key julia-mode-map (kbd "C-c C-c") #'julia-shell-save-and-go)
(define-key julia-mode-map (kbd "C-c C-p") #'run-julia)
(define-key julia-mode-map (kbd "C-c C-r") #'julia-shell-run-region-or-line)

;; Lua language
(require 'lua-mode)
(setq lua-indent-level 4)

;; python language
(require 'company-jedi)
(require 'python)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i")
(add-to-list 'company-backends 'company-jedi)

;; rust language
(require 'rust-mode)
(require 'cargo)
(require 'racer)
(require 'company-racer)
(require 'flycheck-rust)
(setq racer-rust-src-path "/usr/src/rust/src")
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-racer))
(add-hook 'rust-mode-hook #'cargo-minor-mode)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'rust-mode-hook #'flycheck-rust-setup)

;; interpreters
(add-hook 'comint-mode-hook (lambda () (linum-mode -1)))

(provide 'init)
;;; init ends here
