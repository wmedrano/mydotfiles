;;; wmedrano-emacs --- Summary:
;;;   Use icons in the modeline.
;;; Commentary:
;;;   wmedrano@gmail.com
;;; Code:

;;;###autoload
(defun icons-setup-modeline-format ()
  "Setup the mode-line format for icons."
  (interactive)
  (require 'evil)
  (require 'flycheck)
  (require 'magit)
  (setq-default mode-line-format
		`("%e"
		  mode-line-front-space
		  mode-line-mule-info
		  mode-line-client
		  mode-line-modified
		  mode-line-remote
		  mode-line-frame-identification
		  mode-line-buffer-identification
		  "   "
		  mode-line-position
		  evil-mode-line-tag

		  ;;; version control
		  (vc-mode ("  "
			    (:eval (all-the-icons-faicon "code-fork"
							 :height 0.9
							 :v-adjust 0))
			    (:eval (propertize (truncate-string-to-width vc-mode 25 nil nil "...")))))
		  "  "
		  mode-line-modes mode-line-misc-info mode-line-end-spaces)
		))



(provide 'icons-modeline)
;;; icons-modeline.el ends here
