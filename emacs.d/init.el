;;; package --- init
;;; Commentary:
;;;     If packages are missing, use (my-install-packages)
;;; Code:

;; disable startup screen
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(column-number-mode t)
 '(company-idle-delay 0.05)
 '(company-minimum-prefix-length 1)
 '(company-selection-wrap-around t)
 '(company-tooltip-align-annotations t)
 '(company-tooltip-limit 30)
 '(company-tooltip-minimum-width 76)
 '(custom-safe-themes
   (quote
    ("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
 '(eldoc-idle-delay 0.1)
 '(fill-column 80)
 '(flycheck-checker-error-threshold 1000)
 '(flycheck-display-errors-delay 0.1)
 '(flycheck-idle-change-delay 1.0)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(linum-format "%d ")
 '(lua-indent-level 4)
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(mouse-autoselect-window t)
 '(package-selected-packages
   (quote
    (ac-python auto-complete yasnippet which-key toml-mode smart-mode-line racer neotree monokai-theme markdown-mode magit lua-mode key-chord julia-mode irony-eldoc ibuffer-vc hindent helm-projectile helm-package helm-flyspell helm-descbinds helm-company helm-ag go-eldoc gitconfig-mode git-gutter flyspell-popup flycheck-tip flycheck-rust flycheck-irony flycheck-haskell flx-ido evil-commentary evil-anzu diminish company-racer company-quickhelp company-jedi company-irony company-go company-ghc cider cargo benchmark-init ag ace-window ace-jump-buffer)))
 '(projectile-completion-system (quote helm))
 '(projectile-switch-project-action (quote neotree-projectile-action))
 '(projectile-use-git-grep t)
 '(python-shell-interpreter "ipython")
 '(python-shell-interpreter-args "-i")
 '(racer-rust-src-path "/usr/src/rust/src")
 '(sml/name-width 24)
 '(sml/theme (quote respectful))
 '(tool-bar-mode nil)
 '(which-key-idle-delay 0.5)
 '(which-key-lighter nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 119 :width normal))))
 '(popup-tip-face ((t (:background "#F0F0DF" :foreground "#272822")))))

(require 'package)
(add-to-list 'package-archives '("marmalade"
                                 . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(defvar my-packages '(
                      ace-jump-buffer ; navigate buffers better
                      ace-window ; navigate windows better
                      ag ; code searching tool that is better than ack
                      benchmark-init ; benchmark emacs
                      cargo ; rust's package manager
                      cider ; clojure(script) development environment
                      clojure-mode ; clojure/clojurescript programming language
                      company ; complete-anything
                      company-ghc ; haskell completions through ghc
                      company-go ; gocode backend for company
                      company-irony ; irony backend for company
                      company-jedi ; jedi backend for company
                      company-quickhelp ; documentation for company completions
                      company-racer ; rust racer backend for company
                      diminish ; make mode-line cleaner by removing some modes
                      irony-eldoc ; irony integration for eldoc
                      evil ; extensible vi layer
                      evil-anzu ; displays number of matches for buffer searches
                      evil-commentary ; comment out lines of code
                      flycheck ; on-the-fly syntax checking
                      flycheck-haskell ; flycheck fixes for haskell
                      flycheck-irony ; irony integration for flycheck
                      flycheck-rust ; flycheck fixes for rust
                      flycheck-tip ; show flycheck errors in popup
                      flyspell-popup ; popup for flyspell
                      flx-ido ; better fuzzy matching for ido
                      ghc ; happy haskell programming
                      git-gutter ; show git information in gutter area
                      gitconfig-mode ; editing for .gitconfig files
                      go-eldoc ; eldoc support for go programming language
                      go-mode ; go programming language
                      haskell-mode ; haskell programming language
                      helm ; incremental completions
                      helm-ag ; Silver search with helm interface
                      helm-company ; helm for company completions
                      helm-descbinds ; helm for displaying keybindings
                      helm-package ; helm for installing packages
                      helm-projectile ; helm integration for projectile
                      helm-flyspell ; helm integration for flyspell
                      hindent ; haskell indentations
                      ibuffer ; replacement for BufferMenu
                      ibuffer-vc ; vc integration for ibuffer
                      irony ; really nice clang integration
                      julia-mode ; julia programming language
                      key-chord ; map simultaneously pressed keys to commands
                      lua-mode ; lua programming language
                      magit ; git interface
                      markdown-mode ; editing for markdown text files
                      monokai-theme ; decent dark theme
                      neotree ; file tree
                      projectile ; project interaction
                      racer ; rust code completion
                      rust-mode ; rust programming language
                      smart-mode-line ; better mode-line
                      toml-mode ; editing for toml files
                      which-key ; help for key shortcuts
                      yasnippet ; template
                      ))

(defun my-install-packages ()
  "Refresh package archive and install packages."
  (interactive)
  (package-refresh-contents)
  (dolist (package my-packages) (package-install package)))

(require 'benchmark-init)
(benchmark-init/activate)

(require 'company)
(require 'evil)
(require 'flycheck)
(require 'flycheck-tip)
(require 'flyspell)
(require 'ibuffer)
(require 'neotree)
(require 'projectile)
(require 'yasnippet)
(defalias 'yes-or-no-p 'y-or-n-p)

;;
(column-number-mode)
(if (display-graphic-p) (company-quickhelp-mode +1))
(electric-pair-mode +1)
(evil-commentary-mode +1)
(flycheck-tip-use-timer 'verbose)
(global-anzu-mode +1)
(global-git-gutter-mode +1)
(git-gutter:linum-setup)
(global-linum-mode +1)
(helm-mode +1)
(ido-mode 1)
(key-chord-mode +1)
(projectile-global-mode)
(yas-global-mode +1)
(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets/")
(which-key-mode)

;; general hooks
(defun my-ibuffer-setup ()
  "VC integration for ibuffer."
  (ibuffer-vc-set-filter-groups-by-vc-root)
  (unless (eq ibuffer-sorting-mode 'alphabetic)
    (ibuffer-do-sort-by-alphabetic)))
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'prog-mode-hook #'auto-fill-mode)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)
(add-hook 'prog-mode-hook #'git-gutter)
(add-hook 'text-mode-hook #'flyspell-mode)
(add-hook 'text-mode-hook #'git-gutter)
(add-hook 'ibuffer-hook #'my-ibuffer-setup)

;; c like languages
(defun my-c-indentations ()
  "Indentations for c like languages."
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0))
(add-hook 'c-mode-common-hook #'my-c-indentations)

;; c/c++, objc
(with-eval-after-load 'company
  (add-to-list 'company-backend 'company-irony))
(add-hook 'c++-mode-hook #'irony-mode)
(add-hook 'c-mode-hook #'irony-mode)
(add-hook 'objc-mode-hook #'irony-mode)
(add-hook 'irony-mode-hook #'company-mode)
(add-hook 'irony-mode-hook #'flycheck-mode)
(add-hook 'irony-mode-hook #'flycheck-irony-setup)
(add-hook 'irony-mode-hook #'irony-eldoc)

;; clojure language
(add-hook 'cider-mode-hook #'company-mode)
(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-repl-mode-hook #'eldoc-mode)
(add-hook 'clojure-mode-hook #'eldoc-mode)

;; go language
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-go))
(add-hook 'go-mode-hook #'company-mode)
(add-hook 'go-mode-hook #'eldoc-mode)
(add-hook 'go-mode-hook #'go-eldoc-setup)
(add-hook 'go-mode-hook #'flycheck-mode)

;; emacs lisp language
(add-hook 'emacs-lisp-mode-hook #'company-mode)
(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)

;; haskell language
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-ghc))
(add-hook 'haskell-mode-hook #'hindent-mode)
(add-hook 'haskell-mode-hook #'ghc-init)
(add-hook 'haskell-mode-hook #'company-mode)
(add-hook 'haskell-mode-hook #'flycheck-mode)
(add-hook 'haskell-mode-hook #'flycheck-haskell-setup)
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)

;; lua
(add-hook 'lua-mode-hook #'company-mode)
(add-hook 'lua-mode-hook #'eldoc-mode)
(add-hook 'lua-mode-hook #'flycheck-mode)

;; python
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook #'company-mode)
(add-hook 'python-mode-hook #'eldoc-mode)
(add-hook 'python-mode-hook #'flycheck-mode)

;; rust language
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-racer))
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'rust-mode-hook #'cargo-minor-mode)
(add-hook 'rust-mode-hook #'flycheck-mode)
(add-hook 'rust-mode-hook #'flycheck-rust-setup)
(add-hook 'rust-mode-hook #'racer-mode)

;; theme
(load-theme 'monokai t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(sml/setup)
(tool-bar-mode -1)
(xterm-mouse-mode)

;; evil keybindings
(evil-mode 1)
(key-chord-define evil-insert-state-map "jj" #'evil-normal-state)
(define-key evil-normal-state-map (kbd "TAB") #'indent-for-tab-command)
(define-key evil-visual-state-map (kbd "TAB") #'indent-for-tab-command)
(define-key evil-normal-state-map "K" #'evil-scroll-up)
(define-key evil-normal-state-map "J" #'evil-scroll-down)

;; windows
(global-set-key (kbd "\C-w") #'evil-window-map)
(global-set-key (kbd "\C-w SPC") #'ace-window)

;; neotree
(add-to-list 'evil-emacs-state-modes 'neotree-mode)
(global-set-key [f8] #'neotree-toggle)
(define-key neotree-mode-map (kbd "j") #'neotree-next-line)
(define-key neotree-mode-map (kbd "k") #'neotree-previous-line)

;; company completions
(define-key company-active-map (kbd "RET") nil)
(define-key company-active-map (kbd "TAB") 'company-complete-selection)

;; replace things with helm
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "\C-hb") #'helm-descbinds)
(global-set-key (kbd "\C-xb") #'helm-buffers-list)

;; replace buffermenu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)
(define-key ibuffer-mode-map (kbd "/") #'ibuffer-jump-to-buffer)
(define-key ibuffer-mode-map (kbd "j") #'next-line)
(define-key ibuffer-mode-map (kbd "k") #'previous-line)

;; C-c bindings
(define-key flyspell-mode-map (kbd "\C-ca") #'helm-flyspell-correct)
(define-key company-mode-map (kbd "\C-cc") #'helm-company)
(define-key yas-minor-mode-map (kbd "\C-cy") #'yas-insert-snippet)
(global-set-key (kbd "\C-cf") #'helm-projectile-ag)

;; helm replacements
(define-key projectile-command-map (kbd "s g") #'helm-projectile-grep)
(define-key projectile-command-map (kbd "s s") #'helm-projectile-ag)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

(benchmark-init/deactivate)

(provide 'init)
;;; init ends here
