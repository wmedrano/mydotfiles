;;; wmv --- Summary:
;;;   Convenience functions
;;; Commentary:
;;;   will.s.medrano@gmail.com
;;; Code:

(require 'counsel)
(require 'evil)
(require 'neotree)
(require 'projectile)

;;;###autoload
(defun wmv-neotree-toggle-dwim ()
  "Similar to neotree-toggle but it is projectile aware.
Opens in the project root if in a projectile project."
  (interactive)
  (if (and (projectile-project-p) (not (neo-global--window-exists-p)))
      (neotree-projectile-action)
    (neotree-toggle)))

(global-set-key (kbd "<f10>") 'wmv-neotree-toggle-dwim)

;;;###autoload
(defun wmv-ide ()
  "Use IDE layout.
This is calibrated for taking an entire 4k display."
  (interactive)
  (delete-other-windows)

  ;; bottom partition
  (with-selected-window (split-window-below)
    (previous-buffer)
    (evil-window-set-height 16)
    (switch-to-buffer "*compilation*")
    (with-selected-window (split-window-right 104))
    )

  ;; right partition
  (with-selected-window (split-window-right 124)
    (with-selected-window (split-window-below))
    (with-selected-window (split-window-right 104)))
  )


(require 'magit)
(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer buffer '(display-buffer-same-window))))

;;;###autoload
(defun wmv-git ()
  "Use git layout."
  (interactive)
  (delete-other-windows)

  ;; left partition
  (magit-diff-working-tree)

  ;; bottom partition
  (with-selected-window (split-window-below)
    (evil-window-set-height 20)
    (magit-status-internal default-directory))

  ;; right partition
  (with-selected-window (split-window-right)
    (magit-log-all))

  )

;;;###autoload
(defun wmv-new-ide ()
  "Use IDE layout in a new frame."
  (interactive)
  (with-selected-frame (make-frame)
    (wmv-ide)))

;;;###autoload
(defun wmv-new-git ()
  "Use git layout in a new frame."
  (interactive)
  (with-selected-frame (make-frame)
    (wmv-git)))

(provide 'wmv)
;;; wmv.el ends here
