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
        diff-hl ;; Show git changes in gutter
        diminish ;; Hide minor modes
        evil ;; VIM like keys
        evil-anzu ;; Show number of isearch candidates
        evil-commentary ;; Comment code out easily
        evil-surround ;; Manipulate braces/parenthesis/brackets...
        eyebrowse ;; Window managing
        flycheck ;; Realtime syntax checking
        flycheck-irony ;; Irony backend for flycheck syntax checking
        flycheck-rust ;; Rustc backend for flycheck syntax checking
        flyspell-correct-helm ;; Correct spelling with helm menu
        gitconfig-mode ;; Syntax highlighting for gitconfig files.
        gitignore-mode ;; Syntax highlighting for gitignore files.
        helm ;; Incremental completion framework
        helm-ag ;; Helm frontend for ag
        helm-projectile ;; Helm integration for projectile
        hlinum ;; Highlight current line number
        irony ;; Clang based C/C++ code server
        irony-eldoc ;; Irony backend for documentation
        json-mode ;; Syntax highlighting and utilities for json
        key-chord ;; Map key chords to single function
        leuven-theme ;; Light theme
        log4j-mode ;; log4j syntax highlighting and utilies
        lua-mode ;; Syntax highlighting for lua
        magit ;; Emacs interface for git
        markdown-mode ;; Markdown syntax highlighting and utilies
        mode-icons ;; Replace some modeline modes text with icons
        neotree ;; File tree
        nyan-mode ;; Nyan cat in modeline to show position of buffer
        projectile ;; Project navigation and management
        racer ;; Racer in Emacs
        rust-mode ;; Rust syntax highlighting and formatting
        spaceline ;;
        sql-mode ;; SQL syntax highlighting
        syslog-mode ;; syslog syntax highlighting and utilities
        toml-mode ;; Syntax highlighting for TOML
        volatile-highlights ;; Highlight undo/redo affected areas
        which-key ;; Discover prefix keys
        yahoo-weather ;; weather info in modeline
        yaml-mode ;; yaml syntax highlighting and utilities
        zerodark-theme ;; Dark theme
	))

(defun my-install-packages ()
  "Refresh contents from melpa and install the necessary packages."
  (interactive)
  (package-refresh-contents)
  (package-install-selected-packages)
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

(require 'helm)

;; helm-projectile-ag for searching
(require 'helm-projectile)
(define-key evil-motion-state-map (kbd "g/") 'helm-projectile-ag) ;; search in project
(define-key evil-motion-state-map (kbd "gp") 'helm-projectile) ;; navigate buffers

;; error navigation
(define-key evil-normal-state-map (kbd "ge") 'flycheck-next-error)

;; extra
(define-key evil-motion-state-map (kbd "gr") 'revert-buffer)

;; use xref to find definitions
(define-key evil-motion-state-map (kbd "gd") 'xref-find-definitions)

;; projectile keys
(define-key projectile-mode-map (kbd "C-c c") 'projectile-compile-project)
(define-key projectile-mode-map (kbd "C-c g") 'projectile-find-tag)
(define-key projectile-mode-map (kbd "C-c r") 'projectile-run-project)
(define-key projectile-mode-map (kbd "C-c s") 'projectile-run-async-shell-command-in-root)
(define-key projectile-mode-map (kbd "C-c t") 'projectile-test-project)



;;; looks

;; light/dark themes

(defun load-dark-theme ()
  "Use the zerodark theme along with its stylish modeline."
  (require 'zerodark-theme)
  (load-theme 'zerodark t)
  (zerodark-setup-modeline-format))

(require 'nyan-mode)
(defun load-light-theme ()
  "Use the leuven theme."
  (require 'leuven-theme)
  (load-theme 'leuven t)
  (nyan-mode)
  (nyan-start-animation)
  (nyan-toggle-wavy-trail))

(if (string= (getenv "COLOR_SCHEME") "dark")
	(load-dark-theme)
	(load-light-theme))

(require 'spaceline)
(require 'spaceline-config)
(require 'all-the-icons)
(spaceline-define-segment
    ati-modified "An `all-the-icons' modified segment"
    (let* ((config-alist
            '(("*" all-the-icons-faicon-family all-the-icons-faicon "chain-broken" :height 1.2 :v-adjust -0.0)
              ("-" all-the-icons-faicon-family all-the-icons-faicon "link" :height 1.2 :v-adjust -0.0)
              ("%" all-the-icons-octicon-family all-the-icons-octicon "lock" :height 1.2 :v-adjust 0.1)))
           (result (cdr (assoc (format-mode-line "%*") config-alist))))

      (propertize (format "%s" (apply (cadr result) (cddr result))) 'face `(:family ,(funcall (car result)) :inherit )))
    :tight t)

(spaceline-define-segment
    ati-window-numbering "An `all-the-icons' window numbering segment"
    (propertize (format "%c" (+ 9311 (window-numbering-get-number)))
                'face `(:height 1.3 :inherit)
                'display '(raise -0.0))
    :tight t :when (fboundp 'window-numbering-mode))

(spaceline-define-segment
    ati-projectile "An `all-the-icons' segment for current `projectile' project"
    (concat
     (propertize "|" 'face '(:height 1.1 :inherit))
     " "
     (if (and (fboundp 'projectile-project-name)
              (projectile-project-name))
         (propertize (format "%s" (concat (projectile-project-name) ))
                     'face '(:height 0.8 :inherit)
                     'display '(raise 0.2)
                     'help-echo "Switch Project"
                     'mouse-face '(:box 1)
                     'local-map (make-mode-line-mouse-map
                                 'mouse-1 (lambda () (interactive) (projectile-switch-project))))
       (propertize "×" 'face '(:height 0.8 :inherit)))
     " "
     (propertize "|" 'face '(:height 1.1 :inherit)))
    :tight t)

(spaceline-define-segment
    ati-mode-icon "An `all-the-icons' segment for the current buffer mode"
    (let ((icon (all-the-icons-icon-for-buffer)))
      (unless (symbolp icon) ;; This implies it's the major mode
        (propertize icon
                    'help-echo (format "Major-mode: `%s`" major-mode)
                    'display '(raise 0.0)
                    'face `(:height 1.0 :family ,(all-the-icons-icon-family-for-buffer) :inherit)))))

(spaceline-define-segment
    ati-buffer-id "An `all-the-icons' segment for the current buffer id"
    (if (fboundp 'projectile-project-root)
        (let* ((buf (or (buffer-file-name) (buffer-name)))
               (proj (ignore-errors (projectile-project-root)) )
               (name (if (buffer-file-name)
                         (or (cadr (split-string buf proj))
                             (format-mode-line "%b"))
                       (format-mode-line "%b"))))
          (propertize (format "%s" name)
                      'face `(:height 0.8 :inherit)
                      'display '(raise 0.2)
                      'help-echo (format "Major-mode: `%s`" major-mode)))
      (propertize (format-mode-line "%b ") 'face '(:height 0.8 :inherit) 'display '(raise 0.1)))
    :tight t)

;;----------------;;
;; Second Segment ;;
;;----------------;;

(spaceline-define-segment
    ati-process "An `all-the-icons' segment for the current process"
    (let ((icon (all-the-icons-icon-for-buffer)))
      (concat
       (when (or (symbolp icon) mode-line-process)
         (propertize (format-mode-line "%m") 'face `(:height 0.8 :inherit) 'display '(raise 0.2)))
       (when mode-line-process
         (propertize (format-mode-line mode-line-process) 'face '(:height 0.7 :inherit) 'display '(raise 0.2)))))
    :tight t)

(spaceline-define-segment
    ati-position "An `all-the-icons' segment for the Row and Column of the current point"
    (propertize (format-mode-line "%l:%c") 'face `(:height 0.9 :inherit) 'display '(raise 0.1)))

(spaceline-define-segment
    ati-region-info "An `all-the-icons' segment for the currently marked region"
    (when mark-active
      (let ((words (count-lines (region-beginning) (region-end)))
            (chars (count-words (region-end) (region-beginning))))
        (concat
         (propertize (format "%s " (all-the-icons-octicon "pencil") words chars)
                     'face `(:family ,(all-the-icons-octicon-family) :inherit) 'display '(raise 0.1))
         (propertize (format "(%s, %s)" words chars)
                     'face `(:height 0.9 :inherit))))))

(spaceline-define-segment
    ati-color-control "An `all-the-icons' segment for the currently marked region" "")


;;----------------;;
;; Third Segement ;;
;;----------------;;

(defun spaceline---github-vc ()
  "Function to return the Spaceline formatted GIT Version Control text."
  (let ((branch (mapconcat 'concat (cdr (split-string vc-mode "[:-]")) "-")))
    (concat
     (propertize (all-the-icons-alltheicon "git") 'face '(:height 1.1 :inherit) 'display '(raise 0.1))
     (propertize " · ")
     (propertize (format "%s" (all-the-icons-octicon "git-branch"))
                 'face `(:family ,(all-the-icons-octicon-family) :height 1.0 :inherit)
                 'display '(raise 0.2))
     (propertize (format " %s" branch) 'face `(:height 0.9 :inherit) 'display '(raise 0.2)))))

(defun spaceline---svn-vc ()
  "Function to return the Spaceline formatted SVN Version Control text."
  (let ((revision (cadr (split-string vc-mode "-"))))
    (concat
     (propertize (format " %s" (all-the-icons-faicon "cloud")) 'face `(:height 1.2) 'display '(raise -0.1))
     (propertize (format " · %s" revision) 'face `(:height 0.9)))))


(spaceline-define-segment
    ati-vc-icon "An `all-the-icons' segment for the current Version Control icon"
    (when vc-mode
      (cond ((string-match "Git[:-]" vc-mode) (spaceline---github-vc))
            ((string-match "SVN-" vc-mode) (spaceline---svn-vc))
            (t (propertize (format "%s" vc-mode)))))
    :when active)

(spaceline-define-segment
    ati-flycheck-status "An `all-the-icons' representaiton of `flycheck-status'"
    (let* ((text
            (pcase flycheck-last-status-change
              (`finished (if flycheck-current-errors
                             (let ((count (let-alist (flycheck-count-errors flycheck-current-errors)
                                            (+ (or .warning 0) (or .error 0)))))
                               (format "✖ %s Issue%s" count (if (eq 1 count) "" "s")))
                           "✔ No Issues"))
              (`running     "⟲ Running")
              (`no-checker  "⚠ No Checker")
              (`not-checked "✖ Disabled")
              (`errored     "⚠ Error")
              (`interrupted "⛔ Interrupted")
              (`suspicious  "")))
           (f (cond
               ((string-match "⚠" text) `(:height 0.9 :foreground ,(face-attribute 'spaceline-flycheck-warning :foreground)))
               ((string-match "✖ [0-9]" text) `(:height 0.9 :foreground ,(face-attribute 'spaceline-flycheck-error :foreground)))
               ((string-match "✖ Disabled" text) `(:height 0.9 :foreground ,(face-attribute 'font-lock-comment-face :foreground)))
               (t '(:height 0.9 :inherit)))))
      (propertize (format "%s" text)
                  'face f
                  'help-echo "Show Flycheck Errors"
                  'display '(raise 0.2)
                  'mouse-face '(:box 1)
                  'local-map (make-mode-line-mouse-map 'mouse-1 (lambda () (interactive) (flycheck-list-errors)))))
    :when active :tight t )

(defvar spaceline--upgrades nil)
(defun spaceline--count-upgrades ()
  "Function to count the number of package upgrades needed."
  (let ((buf (current-buffer)))
    (package-list-packages-no-fetch)
    (with-current-buffer "*Packages*"
      (setq spaceline--upgrades (length (package-menu--find-upgrades))))
    (switch-to-buffer buf)))
(advice-add 'package-menu-execute :after 'spaceline--count-upgrades)

(spaceline-define-segment
    ati-package-updates "An `all-the-icons' spaceline segment to indicate number of package updates needed"
    (let ((num (or spaceline--upgrades (spaceline--count-upgrades))))
      (propertize
       (concat
        (propertize (format "%s" (all-the-icons-octicon "package"))
                    'face `(:family ,(all-the-icons-octicon-family) :height 1.1 :inherit)
                    'display '(raise 0.1))
        (propertize (format " %d updates " num) 'face `(:height 0.9 :inherit) 'display '(raise 0.2)))
       'help-echo "Open Packages Menu"
       'mouse-face '(:box 1)
       'local-map (make-mode-line-mouse-map
                   'mouse-1 (lambda () (interactive) (package-list-packages)))))
    :when (and active (> (or spaceline--upgrades (spaceline--count-upgrades)) 0)))

;;---------------------;;
;; Right First Segment ;;
;;---------------------;;
(require 'yahoo-weather)
(defun spaceline--get-temp ()
  "Function to return the Temperature formatted for ATI Spacline."
  (let ((temp (yahoo-weather-info-format yahoo-weather-info "%(temperature)")))
    (unless (string= "" temp) (format "%s°C" (round (string-to-number temp))))))

(spaceline-define-segment
    ati-weather "Weather"
    (let* ((weather (yahoo-weather-info-format yahoo-weather-info "%(weather)"))
           (temp (spaceline--get-temp))
           (help (concat "Weather is '" weather "' and the temperature is " temp))
           (icon (all-the-icons-icon-for-weather (downcase weather))))
      (concat
       (if (> (length icon) 1)
           (propertize icon 'help-echo help 'face `(:height 0.9 :inherit) 'display '(raise 0.1))
           (propertize icon
                    'help-echo help
                    'face `(:height 0.9 :family ,(all-the-icons-wicon-family) :inherit)
                    'display '(raise 0.0)))
       (propertize " " 'help-echo help)
       (propertize (spaceline--get-temp) 'face '(:height 0.9 :inherit) 'help-echo help)))
    :when (and active (boundp 'yahoo-weather-info) yahoo-weather-mode)
    :enabled nil
    :tight t)

(spaceline-define-segment
    ati-suntime "Suntime"
    (let ((help (yahoo-weather-info-format yahoo-weather-info "Sunrise at %(sunrise-time), Sunset at %(sunset-time)")))
      (concat
       (propertize (yahoo-weather-info-format yahoo-weather-info "%(sunrise-time) ")
                   'face '(:height 0.9 :inherit) 'display '(raise 0.1) 'help-echo help)
       (propertize (format "%s" (all-the-icons-wicon "sunrise" :v-adjust 0.1))
                   'face `(:height 0.8 :family ,(all-the-icons-wicon-family) :inherit) 'help-echo help)
       (propertize " · " 'help-echo help)
       (propertize (yahoo-weather-info-format yahoo-weather-info "%(sunset-time) ")
                   'face '(:height 0.9 :inherit) 'display '(raise 0.1) 'help-echo help)
       (propertize (format "%s" (all-the-icons-wicon "sunset" :v-adjust 0.1))
                   'face `(:height 0.8 :family ,(all-the-icons-wicon-family) :inherit) 'help-echo help)))
    :when (and active (boundp 'yahoo-weather-info) yahoo-weather-mode)
    :enabled nil
    :tight t )

(spaceline-define-segment
    ati-time "Time"
    (let* ((hour (string-to-number (format-time-string "%I")))
           (icon (all-the-icons-wicon (format "time-%s" hour) :v-adjust 0.0)))
      (concat
       (propertize (format-time-string "%H:%M ") 'face `(:height 0.9 :inherit) 'display '(raise 0.1))
       (propertize (format "%s" icon)
                   'face `(:height 0.8 :family ,(all-the-icons-wicon-family) :inherit)
                   'display '(raise 0.1))))
    :tight t)

(spaceline-define-segment
    ati-height-modifier "Modifies the height of inactive buffers"
    (propertize " " 'face '(:height 1.3 :inherit))
    :tight t :when (not active))

(spaceline-define-segment
    ati-buffer-size "Buffer Size"
    (propertize (format-mode-line "%I") 'face `(:height 0.9 :inherit) 'display '(raise 0.1))
    :tight t)

(spaceline-define-segment
    ati-battery-status "Show battery information"
    (let* ((charging? (equal "AC" (cdr (assoc ?L fancy-battery-last-status))))
           (percentage (string-to-int (cdr (assoc ?p fancy-battery-last-status))))
           (time (format "%s" (cdr (assoc ?t fancy-battery-last-status))))
           (icon-set (if charging? 'alltheicon 'faicon))
           (icon-alist
            (cond
             (charging? '((icon . "charging") (inherit . success) (height . 1.3) (raise . -0.1)))
             ((> percentage 95) '((icon . "full") (inherit . success)))
             ((> percentage 70) '((icon . "three-quarters")))
             ((> percentage 35) '((icon . "half")))
             ((> percentage 15) '((icon . "quarter") (inherit . warning)))
             (t '((icon . "empty") (inherit . error)))))
           (icon-f (all-the-icons--function-name icon-set))
           (family (funcall (all-the-icons--family-name icon-set))))
      (let-alist icon-alist
        (concat
         (if .inherit
             (let ((fg (face-attribute .inherit :foreground)))
               (propertize (funcall icon-f (format "battery-%s" .icon))
                           'face `(:height ,(or .height 1.0) :family ,family :foreground ,fg)
                           'display `(raise ,(or .raise 0.0))))
             (propertize (funcall icon-f (format "battery-%s" .icon))
                         'face `(:family ,family :inherit)
                         'display '(raise 0.0)))
         " "
         (if .inherit
             (let ((fg (face-attribute .inherit :foreground)))
               (propertize (if charging? (format "%s%%%%" percentage) time) 'face `(:height 0.9 :foreground ,fg)))
           (propertize time 'face '(:height 0.9 :inherit)))
         )))
    :global-override fancy-battery-mode-line :when (and active (fboundp 'fancy-battery-mode) fancy-battery-mode))

(require 'spaceline)
(defun spaceline--direction (dir)
  "Inverts DIR from right to left & vice versa."
  (if spaceline-invert-direction (if (equal dir "right") "left" "right") dir))

(defun spaceline--separator-type ()
  "Static function to return the separator type."
  spaceline-separator-type)

(defmacro define-separator (name dir start-face end-face &optional invert)
  "Macro to defined a NAME separator in DIR direction.
Provide the START-FACE and END-FACE to describe the way it should
fade between segmeents.  When INVERT is non-nil, it will invert
the directions of the separator."
  `(progn
     (spaceline-define-segment
         ,(intern (format "ati-%s-separator" name))
       (let ((dir (if spaceline-invert-direction (spaceline--direction ,dir) ,dir))
             (sep (spaceline--separator-type)))
         (propertize (all-the-icons-alltheicon (format "%s-%s" sep dir) :v-adjust 0.0)
                     'face `(:height 1.5
                             :family
                             ,(all-the-icons-alltheicon-family)
                             :foreground
                             ,(face-attribute ,start-face :background)
                             :background
                             ,(face-attribute ,end-face :background))))
       :skip-alternate t :tight t :when (if ,invert (not active) active))))

(defvar spaceline-invert-direction t)
(defvar spaceline-separator-type "slant")

(define-separator "left-inactive" "right" 'powerline-inactive1 'powerline-inactive2 t)
(define-separator "right-inactive" "left" 'powerline-inactive2 'mode-line-inactive t)

(define-separator "left-1" "right" 'spaceline-highlight-face 'powerline-active1)
(define-separator "left-2" "right" 'powerline-active1 'spaceline-highlight-face)
(define-separator "left-3" "right" 'spaceline-highlight-face 'mode-line)
(define-separator "left-4" "right" 'mode-line 'powerline-active2)

(define-separator "right-1" "left" 'powerline-active2 'powerline-active1)
(define-separator "right-2" "left" 'powerline-active1 'mode-line)

(spaceline-compile
 "ati"
 '(
   ((ati-modified ati-window-numbering ati-buffer-size) :face highlight-face :skip-alternate t)
   ;; left-active-3
   ati-left-1-separator
   ((ati-projectile ati-mode-icon ati-buffer-id) :face default-face)
   ati-left-2-separator
   ((ati-process ati-position ati-region-info) :face highlight-face :separator " | ")
   ati-left-3-separator
   ati-left-inactive-separator
   ((ati-vc-icon ati-flycheck-status ati-package-updates purpose) :separator " · " :face other-face)
   ati-left-4-separator)

 '(ati-right-1-separator
   ((ati-suntime ati-weather) :separator " · " :face other-face)
   ati-right-2-separator
   ati-right-inactive-separator
   ((ati-battery-status ati-time) :separator " | " :face other-face)
   ))

(setq-default mode-line-format '("%e" (:eval (spaceline-ml-ati))))


;; font
(require 'all-the-icons)
(setq all-the-icons-scale-factor 1.0)
(custom-set-faces '(default ((t (:family "Source Code Pro"
                                 :foundry "ADBO"
                                 :slant normal
                                 ;; :weight semi-bold
                                 :height 120
                                 :width normal)))))

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

;; show number of matches when searching a buffer
(require 'evil-anzu)
(global-anzu-mode)

;; highlight changes when using undo/redo functions
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; show keymap after pressing a prefix key
(require 'which-key)
(setq which-key-idle-delay 0.7)
(which-key-mode)



;;; buffer/file formatting

;; disk and backups
(setq backup-directory-alist '(("." . "~/.saves")))
(global-auto-revert-mode t)

;; formatting
(setq-default indent-tabs-mode nil
	      fill-column 80)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; parenthesis
(electric-pair-mode t)



;;; git integration

;; fix magit for evil
(require 'magit)
(setq auto-revert-check-vc-info t)
(add-to-list 'evil-motion-state-modes 'magit-diff-mode)
(add-to-list 'evil-motion-state-modes 'magit-status-mode)
(define-key magit-diff-mode-map (kbd "r") 'magit-refresh-all)
(define-key magit-status-mode-map (kbd "r") 'magit-refresh-all)

;; show info in gutter
(require 'diff-hl)
(require 'diff-hl-flydiff)
(setq diff-hl-flydiff-delay 1.0)
(global-diff-hl-mode t)
(diff-hl-flydiff-mode t)



;;; emacs/project management

;; projectile - project management
(require 'projectile)
(setq
 projectile-ignored-project-function
 (lambda (root)
   nil))
(projectile-mode t)

;; helm - incremental completion
(require 'helm)
(require 'helm-projectile)
(setq helm-always-two-windows t
      helm-move-to-line-cycle-in-source t)
(helm-mode t)
(helm-projectile-on)
(global-set-key (kbd "M-x") 'helm-M-x)

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



;;; misc
(setq mouse-autoselect-window t
      browse-url-browser-function 'browse-url-chromium)
(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f11>") (lambda () (interactive) (load-file "~/.emacs.d/init.el")))



;;; window management
(require 'eyebrowse)
(eyebrowse-mode)
(define-key eyebrowse-mode-map (kbd "C-c j") 'eyebrowse-switch-to-window-config)
(define-key eyebrowse-mode-map (kbd "C-c J") 'eyebrowse-rename-window-config)
(define-key eyebrowse-mode-map (kbd "C-c k") 'eyebrowse-create-window-config)
(define-key eyebrowse-mode-map (kbd "C-c K") 'eyebrowse--delete-window-config)
(define-key eyebrowse-mode-map (kbd "C-c w") 'ace-window)
(define-key evil-motion-state-map (kbd "gw") 'ace-window)
(define-key evil-normal-state-map (kbd "gw") nil)



;;; IDE features, auto-complete, code documentation, and syntax checking.

;; company - auto-completion
(require 'company)
(require 'company-flx)
(setq company-idle-delay 0.4
      company-minimum-prefix-length 2
      company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-tooltip-limit 20
      company-tooltip-minimum 20
      company-tooltip-minimum-width 60)
;; fuzzy matching and automatically show docs
(add-hook 'company-mode-hook 'company-flx-mode)
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
(require 'flyspell-correct-helm)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(define-key flyspell-mode-map (kbd "C-c a") 'flyspell-correct-previous-word-generic)



;;; compilation mode - runs processes and shows output
(add-to-list 'evil-motion-state-modes 'compilation-mode)
;; don't shadow evil's bindings
(setq comint-scroll-to-bottom-on-output t)
(define-key compilation-mode-map (kbd "g") nil)
(define-key compilation-mode-map (kbd "h") nil)
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
	    (setq-local fill-column 100)
            (setq-local projectile-tags-command "~/.cargo/bin/rusty-tags emacs")
	    (setq-local projectile-project-compilation-cmd "cargo build")
	    (setq-local projectile-project-run-cmd "cargo run")
	    (setq-local projectile-project-test-cmd "cargo test")))
(add-hook 'racer-mode-hook
	  (lambda ()
            (evil-local-set-key evil-normal-state-map (kbd "gd") nil)
            (evil-local-set-key evil-motion-state-map (kbd "gd") 'racer-find-definition)))


;; hide all minor modes
(require 'diminish)
(diminish 'anzu-mode)
(diminish 'auto-revert-mode)
(diminish 'company-mode)
(diminish 'eldoc-mode)
(diminish 'evil-commentary-mode)
(diminish 'evil-surround-mode)
(diminish 'flycheck-mode)
(diminish 'flyspell-mode)
(diminish 'helm-mode)
(diminish 'irony-mode)
(diminish 'racer-mode)
(diminish 'undo-tree-mode)
(diminish 'volatile-highlights-mode)
(diminish 'which-key-mode)


(provide 'init)
;;; init.el ends here
