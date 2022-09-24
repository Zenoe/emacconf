;;; emacconf/window.el -*- lexical-binding: t; -*-

;; in evil mode, this setting would be override by
;; (define-key evil-normal-state-map (kbd "C-.") 'evil-repeat-pop) in
;; straight/repos/evil/evil-maps.el

(global-set-key (kbd "C-.") #'other-window)

;; use this setting for good
(define-key evil-normal-state-map (kbd "C-.") 'other-window)
(global-set-key (kbd "C-,") #'prev-window)
(defun prev-window ()
  (interactive)
  (other-window -1))

(defun toggle-window-split ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (> (length (window-list)) 2)
      (error "Can't toggle with more than 2 windows!")
    (let ((func (if (window-full-height-p)
                    #'split-window-vertically
                  #'split-window-horizontally)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window 1)
        (switch-to-buffer (other-buffer))))))

(global-set-key (kbd "C-x w") 'toggle-window-split)

;; (global-set-key [M-left] 'windmove-left)
;; (global-set-key [M-right] 'windmove-right)
;; (global-set-key [M-up] 'windmove-up)
;; (global-set-key [M-down] 'windmove-down)
