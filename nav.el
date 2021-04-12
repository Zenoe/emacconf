;;; ~/.doom.d/mysetting/nav.el -*- lexical-binding: t; -*-

;; (require 'helm-grep)
;; (defun project-helm-do-grep-ag (arg)
;;   "Preconfigured helm for grepping with AG in `default-directory'.
;; With prefix-arg prompt for type if available with your AG version."
;;   (interactive "P")
;;   (require 'helm-files)
;;   (helm-grep-ag (expand-file-name ( projectile-project-root )) arg))
;;

;; pass function ivy-thing-at-point to counsel-projectile-ag
;; which is eval(ed) and the result is pass to counsel-ag

(setq counsel-projectile-ag-initial-input  '( ivy-thing-at-point ) )
(defun ivy-with-thing-at-point (cmd)
  (let ((ivy-initial-inputs-alist
         (list
          (cons cmd (thing-at-point 'symbol)))))
    (funcall cmd)))

(defun counsel-ag-apt ()
  (interactive)
  (ivy-with-thing-at-point 'counsel-projectile-ag))

(defun swiper-apt ()
  (interactive)
  (ivy-with-thing-at-point 'swiper))

(defun selection-or-thing-at-point ()
  (cond ;; If there is selection use it
   ((and transient-mark-mode mark-active (not (eq (mark) (point))))
    (let ((mark-saved (mark)) (point-saved (point))) (deactivate-mark) (buffer-substring-no-properties mark-saved point-saved))) ;; Otherwise, use symbol at point or empty
   (t (format "%s" (or (thing-at-point 'ymbol) "")))))

(defun counsel-ag-at-point ()
  (interactive)
  (counsel-ag (selection-or-thing-at-point) (projectile-project-root)))
