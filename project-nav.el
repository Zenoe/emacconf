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

(defun dired-project-root ()
  (interactive)
  (dired ( projectile-project-root ))
  )
