;;; package --- init
;;; Commentary:
;;;     My Emacs configuration
;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("613a7c50dbea57860eae686d580f83867582ffdadd63f0f3ebe6a85455ab7706" "1e3b2c9e7e84bb886739604eae91a9afbdfb2e269936ec5dd4a9d3b7a943af7f" "c1390663960169cd92f58aad44ba3253227d8f715c026438303c09b9fb66cdfb" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c93fabc360a4b2adb84cc7ab70a717a990777452ab0328b23812c779ff274154" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "1b46826ed71b40396e3eee3a8a8adb0b4e2bf4edeff271116a1926e5c20eede0" default)))
 '(eldoc-echo-area-use-multiline-p t)
 '(fill-column 80)
 '(global-hl-line-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (csharp-mode moe-theme solarized-theme monokai-theme atom-one-dark-theme alect-themes material-theme leuven-theme ace-window clojure-mode-extra-font-locking eclipse-theme smart-mode-line twilight-bright-theme ibuffer-vc ag evil-anzu evil-avy helm-themes helm-flycheck company-quickhelp helm-package git-gutter-fringe git-gutter helm-company helm-rhythmbox js2-mode js-comint nodejs-repl key-chord evil avy toml-mode julia-shell julia-mode undo-tree markdown-mode yafolding eldoc-eval helm-mode-manager gitconfig-mode gitignore-mode neotree benchmark-init company-jedi lua-mode flycheck-haskell company-ghc ghc hindent haskell-mode flyspell-popup go-eldoc company-go cider flycheck-irony irony-eldoc company-irony-c-headers company-irony helm-ag which-key anzu helm-projectile helm projectile magit flycheck-rust cargo company-racer racer rust-mode flycheck company)))
 '(show-paren-delay 0.0)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "PfEd" :slant normal :weight normal :height 113 :width normal)))))

(setq-default indent-tabs-mode nil
	      major-mode 'org-mode)
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
(scroll-bar-mode -1)
(tool-bar-mode -1)
(xterm-mouse-mode +1)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

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
(require 'evil-anzu)
(require 'smart-mode-line)
(require 'undo-tree)
(require 'which-key)
(require 'moe-theme)
(setq anzu-mode-lighter nil
      sml/name-width 32
      sml/theme 'dark
      undo-tree-mode-lighter " ut"
      which-key-idle-delay 0.1
      which-key-lighter nil)
(moe-dark)
(global-anzu-mode +1)
(global-undo-tree-mode +1)
(sml/setup)
(which-key-mode +1)

;;
(require 'ace-window)
(global-set-key (kbd "C-c w") #'ace-window)

;; code folding
(require 'yafolding)
(add-hook 'prog-mode-hook #'yafolding-mode)

;; code documentation
(require 'eldoc)
(setq  eldoc-echo-area-use-multiline-p t
       eldoc-idle-delay 0.05)
(global-eldoc-mode +1)
(eldoc-in-minibuffer-mode +1)

;; auto completions and templates
(require 'company)
;; (require 'yasnippet)
(setq company-lighter " comp"
      company-idle-delay 0.4
      company-minimum-prefix-length 1
      company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-tooltip-limit 24
      company-tooltip-minimum 24
      company-tooltip-minimum-width 64)
;; (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets/")
(define-key company-mode-map (kbd "C-c c") #'helm-company)
;; (define-key yas-minor-mode-map (kbd "C-c y") #'company-yasnippet)
;; (define-key yas-minor-mode-map [(tab)] nil)
;; (define-key yas-minor-mode-map (kbd "TAB") nil)
;; (define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key company-active-map [return] nil)
(define-key company-active-map (kbd "RET") nil)
(define-key company-active-map (kbd "TAB") #'company-complete-selection)
(define-key company-active-map [tab] #'company-complete-selection)
(global-company-mode +1)
;; (yas-global-mode +1)

;; syntax/spell checking
(require 'flycheck)
(require 'flyspell)
(setq flycheck-checker-error-threshold 800
      flycheck-display-errors-delay 0.1
      flycheck-idle-change-delay 1.0
      flyspell-mode-line-string " FlyS")
(define-key flyspell-mode-map (kbd "C-c a") #'flyspell-popup-correct)
(global-flycheck-mode +1)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)
(add-hook 'text-mode-hook #'flyspell-mode)

;; git
(require 'magit)
(require 'git-gutter-fringe)
(global-git-gutter-mode +1)

;; emacs completions and project
(require 'helm)
(require 'helm-mode)
(require 'neotree)
(require 'projectile)
(require 'helm-projectile)
(setq helm-completion-mode-string nil
      neo-window-width 32
      projectile-completion-system 'helm)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-c e") #'eshell)
(global-set-key (kbd "C-c n") #'neotree-toggle)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(define-key projectile-command-map (kbd "n") #'neotree-projectile-action)
(define-key projectile-command-map (kbd "s") #'helm-projectile-ag)
(helm-mode +1)
(projectile-global-mode)

;; buffer menu
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; c/c++/obj-c
(require 'irony)
(require 'company-irony)
(require 'company-irony-c-headers)
(require 'flycheck-irony)
(require 'irony-eldoc)
(with-eval-after-load 'company
  (add-to-list 'company-backends '(company-irony-c-headers company-irony)))
(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
(add-hook 'c++-mode-hook #'irony-mode)
(add-hook 'c-mode-hook #'irony-mode)
(add-hook 'objc-mode-hook #'irony-mode)
(add-hook 'irony-mode-hook #'irony-cdb-autosetup-compile-options)
(add-hook 'irony-mode-hook #'irony-eldoc)

;; clojure language
(require 'cider)

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
(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup)
(add-hook 'haskell-mode-hook #'hindent-mode)
(add-hook 'haskell-mode-hook #'ghc-init)
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)

;; JavaScript language
(require 'js2-mode)
(require 'js-comint)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq inferior-js-program-command "node"
      inferior-js-program-arguments '("--interactive"))
(define-key js2-mode-map (kbd "C-c C-c") #'js-send-buffer)
(define-key js2-mode-map (kbd "C-c C-p") #'run-js)
(define-key js2-mode-map (kbd "C-c C-r") #'js-send-region)

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
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
(add-hook 'rust-mode-hook #'cargo-minor-mode)
(add-hook 'rust-mode-hook #'racer-mode)

;; comint mode - interpreters

;; evil mode
(require 'evil)
(require 'key-chord)
(evil-mode +1)
(key-chord-mode +1)
(key-chord-define evil-insert-state-map "jj" #'evil-normal-state)
(add-to-list 'evil-emacs-state-modes 'neotree-mode)
(add-to-list 'evil-emacs-state-modes 'cider-docview-mode)
(add-to-list 'evil-emacs-state-modes 'cider-stacktrace-mode)
(define-key neotree-mode-map (kbd "j") #'neotree-next-line)
(define-key neotree-mode-map (kbd "k") #'neotree-previous-line)

;; music
(require 'helm-rhythmbox)
(global-set-key (kbd "C-c r") #'helm-rhythmbox)

(provide 'init)
;;; init ends here
