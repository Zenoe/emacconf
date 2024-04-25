;;; emacconf/embark-config.el -*- lexical-binding: t; -*-
;; (defun copy-grep-results-as-kill (strings)
;;   (embark-copy-as-kill
;;    (mapcar (lambda (string)
;;              (substring string
;;                         (1+ (next-single-property-change
;;                              (1+ (next-single-property-change 0 'face string))
;;                              'face string))))
;;            strings)))

(defun copy-line-without-metadata (strings)
  ;; strip leading filename and line number like "embark-config.el:3:(defun embark-copy-as-kill2 (strings)"
  ;; param strings is of list type, embark-copy-as-kill
  (embark-copy-as-kill
   (mapcar (lambda (string)
             (substring string
                        (1+ (string-match ":" string (1+ (string-match ":" string))))
                        (length string)
                        ))
           strings)))

;; (list string): convert single string to a list
(map!
 :map embark-general-map
 :desc "copy text" "x" (lambda (string) ( copy-line-without-metadata (list string) ))
 )


;; not work in eval-buffer, don't know why
;; only work when eval-last-sexp
;; (defvar-keymap embark-general-map
;;   :doc "Example keymap with a few file actions"
;;   :parent embark-general-map
;;   "x" #'copy-grep-results-as-kill)
