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
    ("5a21604c4b1f2df98e67cda2347b8f42dc9ce471a48164fcb8d3d52c3a0d10be" "c1390663960169cd92f58aad44ba3253227d8f715c026438303c09b9fb66cdfb" "95db78d85e3c0e735da28af774dfa59308db832f84b8a2287586f5b4f21a7a5b" "6c62b1cd715d26eb5aa53843ed9a54fc2b0d7c5e0f5118d4efafa13d7715c56e" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "c58382b9c4fff1aa94b8e3f0f81b0212bb554e83f76957bab735f960a4c441b1" "badc4f9ae3ee82a5ca711f3fd48c3f49ebe20e6303bba1912d4e2d19dd60ec98" "cf6d8127339c76d2a4b8165492a2bee417ccd3741d292a80015e95f6e9f8769f" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "38ba6a938d67a452aeb1dada9d7cdeca4d9f18114e9fc8ed2b972573138d4664" "316d29f8cd6ca980bf2e3f1c44d3a64c1a20ac5f825a167f76e5c619b4e92ff4" "1012cf33e0152751078e9529a915da52ec742dabf22143530e86451ae8378c1a" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(eldoc-echo-area-use-multiline-p t)
 '(fill-column 80)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (majapahit-theme twilight-bright-theme twilight-anti-bright-theme apropospriate-theme helm-flycheck hc-zenburn-theme gruvbox-theme anti-zenburn-theme company-quickhelp helm-package git-gutter-fringe git-gutter helm-company helm-rhythmbox js2-mode js-comint nodejs-repl github-theme key-chord evil pastelmac-theme avy solarized-theme toml-mode julia-shell julia-mode undo-tree markdown-mode yafolding zenburn-theme dracula-theme flycheck-clojure eldoc-eval smart-mode-line powerline helm-mode-manager gitconfig-mode gitignore-mode powerline neotree benchmark-init company-jedi lua-mode flycheck-haskell company-ghc ghc hindent haskell-mode flyspell-popup go-eldoc company-go cider flycheck-irony irony-eldoc company-irony-c-headers company-irony helm-ag which-key yasnippet ibuffer-projectile anzu helm-projectile helm projectile magit flycheck-rust cargo company-racer racer rust-mode flycheck company monokai-theme)))
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

(setq-default major-mode 'org-mode)
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
(require 'smart-mode-line)
(require 'undo-tree)
(require 'which-key)
(setq anzu-mode-lighter nil
      sml/name-width 32
      sml/theme 'dark
      undo-tree-mode-lighter " ut"
      which-key-idle-delay 0.3
      which-key-lighter nil)
(global-anzu-mode +1)
(global-undo-tree-mode +1)
(load-theme 'twilight-bright t)
(sml/setup)
(which-key-mode +1)

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
(require 'yasnippet)
(setq company-lighter " comp"
      company-idle-delay 0.1
      company-minimum-prefix-length 1
      company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-tooltip-limit 24
      company-tooltip-minimum 24
      company-tooltip-minimum-width 64)
(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets/")
(define-key company-mode-map (kbd "C-c c") #'helm-company)
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
(define-prefix-command 'magit-command-map)
(global-set-key (kbd "C-c g") #'magit-command-map)
(define-key magit-command-map (kbd "b") #'magit-branch)
(define-key magit-command-map (kbd "c") #'magit-commit)
(define-key magit-command-map (kbd "d") #'magit-diff)
(define-key magit-command-map (kbd "g") #'magit-pull)
(define-key magit-command-map (kbd "p") #'magit-push)
(define-key magit-command-map (kbd "s") #'magit-status)

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
(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
(add-hook 'c++-mode-hook #'irony-mode)
(add-hook 'c-mode-hook #'irony-mode)
(add-hook 'objc-mode-hook #'irony-mode)
(add-hook 'irony-mode-hook #'irony-cdb-autosetup-compile-options)
(add-hook 'irony-mode-hook #'irony-eldoc)

;; clojure language
(require 'cider)
(require 'flycheck-clojure)
(add-hook 'flycheck-mode-hook #'flycheck-clojure-setup)

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
(define-key neotree-mode-map (kbd "j") #'neotree-next-line)
(define-key neotree-mode-map (kbd "k") #'neotree-previous-line)

;; music
(require 'helm-rhythmbox)
(global-set-key (kbd "C-c r") #'helm-rhythmbox)

(provide 'init)
;;; init ends here
