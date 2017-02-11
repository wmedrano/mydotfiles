;;; wm --- Summary:
;;;   Convenience functions
;;; Commentary:
;;;   will.s.medrano@gmail.com
;;; Code:

(require 'evil)
(require 'neotree)
(require 'projectile)

;;;###autoload
(defun wm-neotree-toggle-dwim ()
  "Similar to neotree-toggle but it is projectile aware.
Opens in the project root if in a projectile project."
  (interactive)
  (if (and (projectile-project-p) (not (neo-global--window-exists-p)))
      (neotree-projectile-action)
    (neotree-toggle)))

(global-set-key (kbd "<f10>") 'wm-neotree-toggle-dwim)

;;;###autoload
(defun wm-view-ide ()
  "Use IDE layout.
This is calibrated for taking an entire 4k display."
  (interactive)
  (delete-other-windows)

  ;; bottom partition
  (with-selected-window (split-window-below)
    (previous-buffer)
    (evil-window-set-height 16)
    (switch-to-buffer "*compilation*")
    (with-selected-window (split-window-right 100))
    )

  ;; right partition
  (with-selected-window (split-window-right 128)
    (with-selected-window (split-window-below))
    (with-selected-window (split-window-right 100)))
  )


(require 'magit)
(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer buffer '(display-buffer-same-window))))

;;;###autoload
(defun wm-view-git ()
  "Use git layout."
  (interactive)
  (delete-other-windows)

  ;; main partition
  (magit-diff-working-tree)

  ;; bottom partition
  (with-selected-window (split-window-below)
    (evil-window-set-height 20)
    (magit-status-internal default-directory)
    (with-selected-window (split-window-right)
      (magit-log-all))))

;;;###autoload
(defun wm-new-view-ide ()
  "Use IDE layout in a new frame."
  (interactive)
  (with-selected-frame (make-frame)
    (wm-view-ide)))

;;;###autoload
(defun wm-new-view-git ()
  "Use git layout in a new frame."
  (interactive)
  (with-selected-frame (make-frame)
    (wm-view-git)))

(provide 'wm)
;;; wm.el ends here
