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
 '(eldoc-echo-area-use-multiline-p t)
 '(fill-column 80)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (monokai-theme github-browse-file evil-terminal-cursor-changer diminish evil-commentary evil-surround yaml-mode cython-mode csharp-mode ace-window clojure-mode-extra-font-locking smart-mode-line ibuffer-vc ag evil-anzu evil-avy helm-themes helm-flycheck company-quickhelp helm-package git-gutter-fringe git-gutter helm-company helm-rhythmbox js2-mode js-comint nodejs-repl key-chord evil avy toml-mode julia-shell julia-mode undo-tree markdown-mode yafolding eldoc-eval helm-mode-manager gitconfig-mode gitignore-mode neotree benchmark-init company-jedi lua-mode flycheck-haskell company-ghc ghc hindent haskell-mode flyspell-popup go-eldoc company-go cider flycheck-irony irony-eldoc company-irony-c-headers company-irony helm-ag which-key anzu helm-projectile helm projectile magit flycheck-rust cargo company-racer racer rust-mode flycheck company)))
 '(projectile-globally-ignored-directories
   (quote
    (".idea" ".eunit" ".git" ".hg" ".fslckout" ".bzr" "_darcs" ".tox" ".svn" ".stack-work" ".cargo")))
 '(show-paren-delay 0.0)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "PfEd" :slant normal :weight normal :height 120 :width normal)))))

(setq-default indent-tabs-mode nil
	      major-mode 'org-mode)
(setq indent-tabs-mode nil
      inhibit-startup-screen t
      make-backup-files nil
      mouse-autoselect-window t)
(global-auto-revert-mode)
(global-hl-line-mode)
(column-number-mode +1)
(defalias 'yes-or-no-p 'y-or-n-p)
(electric-pair-mode +1)
(global-linum-mode)
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
(setq anzu-mode-lighter nil
      sml/name-width 32
      sml/no-confirm-load-theme t
      undo-tree-mode-lighter nil
      which-key-idle-delay 0.1
      which-key-lighter nil)
(global-anzu-mode +1)
(global-undo-tree-mode +1)
(which-key-mode +1)

(sml/setup)
(load-theme 'monokai t)
(defun clear-bg ()
  "Clear the background by giving a not color."
  (interactive)
  (set-background-color "#FFFFFFFF"))
(defalias 'cb 'clear-bg)
(add-hook 'text-mode-hook #'clear-bg)
(add-hook 'prog-mode-hook #'clear-bg)

;;
(require 'ace-window)
(global-set-key (kbd "C-c w") #'ace-window)

;; emacs browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium")

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
      neo-window-width 28
      projectile-completion-system 'helm)
(projectile-cleanup-known-projects)
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

;; Emacs lisp
(define-key emacs-lisp-mode-map (kbd "C-c C-r") #'eval-buffer)

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
(setq racer-cmd "racer"
      racer-rust-src-path "/usr/src/rust/src")
(define-key racer-mode-map (kbd "C-c C-d") #'racer-find-definition)
(define-key cargo-minor-mode-map (kbd "C-c C-k") #'cargo-process-build)
(define-key cargo-minor-mode-map (kbd "C-c C-r") #'cargo-process-run)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-racer))
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'rust-mode-hook #'cargo-minor-mode)

;; comint mode - interpreters

;; evil mode
(require 'evil)
(require 'evil-surround)
(require 'evil-commentary)
(require 'key-chord)
(evil-mode +1)
(global-evil-surround-mode +1)
(evil-commentary-mode +1)
(key-chord-mode +1)
(key-chord-define evil-insert-state-map "jj" #'evil-normal-state)
(add-to-list 'evil-emacs-state-modes 'neotree-mode)
(add-to-list 'evil-emacs-state-modes 'cider-docview-mode)
(add-to-list 'evil-emacs-state-modes 'cider-stacktrace-mode)
(define-key evil-normal-state-map (kbd "J") #'evil-scroll-down)
(define-key evil-normal-state-map (kbd "K") #'evil-scroll-up)
(define-key evil-normal-state-map (kbd "C-d") #'evil-join)
(define-key evil-normal-state-map (kbd "q") nil)
(define-key evil-normal-state-map (kbd "g a") #'helm-projectile-ag)
(define-key evil-normal-state-map (kbd "g b") #'github-browse-file)
(define-key evil-normal-state-map (kbd "g f") #'flycheck-next-error)
(define-key evil-normal-state-map (kbd "g m") #'evil-goto-mark)
(define-key evil-normal-state-map (kbd "g p") #'helm-projectile)
(define-key evil-normal-state-map (kbd "g w") #'ace-window)
(define-key neotree-mode-map (kbd "j") #'neotree-next-line)

(define-key neotree-mode-map (kbd "k") #'neotree-previous-line)
(define-key neotree-mode-map (kbd "/") #'isearch-forward)
(add-hook 'neotree-mode-hook (lambda () (linum-mode -1)))

(require 'evil-terminal-cursor-changer)
(setq evil-emacs-state-cursor  '("white" box)
      evil-insert-state-cursor '("#F92672" bar)
      evil-normal-state-cursor '("#66D9EF" box)
      evil-visual-state-cursor '("#A6E22E" box));

;; music
(require 'helm-rhythmbox)
(global-set-key (kbd "C-c r") #'helm-rhythmbox)

(require 'diminish)
(diminish 'evil-commentary-mode)
(diminish 'cargo-minor-mode)
(diminish 'racer-mode)
(diminish 'git-gutter-mode)

(provide 'init)
;;; init ends here
