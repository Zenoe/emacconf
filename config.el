;;; key bindings
;;;
(load-file ( concat myset-folder "./customsetting.el"))
(load-file ( concat myset-folder "./buffer-nav.el"))
(load-file ( concat myset-folder "./project-nav.el"))
(load-file ( concat myset-folder "./quickedit.el"))

;; (nvmap "gl" 'evil-last-non-blank)
;; (nvmap "gy" 'paste-next-line)
(nvmap "gh" 'counsel-projectile-ag)
;; (nvmap "g[" 'counsel-projectile-rg)

(nvmap "gb" 'sp-splice-sexp)
(nvmap "zv" 'selcurrentline)
(nvmap "z0" 'YankFrom0)
(nvmap "z;" 'selectBlock)
(nvmap "zs" 'surround-region-with-if)
(nvmap "zw" 'move-buffer-to-window)
(nvmap "g;" 'gotoLastChange)
(nvmap "ze" 'searchb4spaceorbracket)
(nvmap "z]" 'sgml-skip-tag-forward)
(nvmap "z[" 'sgml-skip-tag-backward)
(nvmap "zp" 'yank-and-indent)
(nvmap "go" 'comment-line)
(nvmap "[e" 'flycheck-previous-error)
(nvmap "]e" 'flycheck-next-error)
(nvmap "zg" 'isearch-forward-region)

;; dumb-jump is much faster then xref-definition, don't know why
(setq +lookup-definition-functions
  '(+lookup-dumb-jump-backend-fn
    +lookup-xref-definitions-backend-fn
    +lookup-project-search-backend-fn
    +lookup-evil-goto-definition-backend-fn)
)

(global-set-key (kbd "C-x C-n") 'yf/replace-or-delete-pair)

(define-key evil-normal-state-map (kbd "M-;")
  ;; insert a character at the end of current line. semicolon default
  (lambda(c)
    (interactive "p")
    (save-excursion
      (let (
            (pt (search-forward "\n"))
            )
        (backward-char)
        (if (= c 1)
            (insert-char ?\;)
          (insert-char c)
          )
        )
      )
    )
  )

(define-key evil-normal-state-map (kbd "RET")
  (lambda(count)
    (interactive "p")
    (if (= count 1)
        (evil-open-below())
      (evil-open-above()))
    (evil-normal-state)))

 ;; (kbd "S-RET") can not bind to shift-return

(global-set-key (kbd "C-x C-e") 'eval-current-line)
;; rebind C-k to evil-jump-forward 'cuase the default binding TAB is not working
;; int terminal emacs. and I don't use C-k in evil mode
(global-set-key (kbd "C-k") 'evil-jump-forward)

(require 'expand-region)
(global-set-key (kbd "M-n") 'er/expand-region)
(global-set-key (kbd "M-p") 'evilnc-copy-and-comment-lines)

(define-key process-menu-mode-map (kbd "C-k") 'joaot/delete-process-at-point)

;; (global-set-key (kbd "M-1")
;;                (lambda()
;;                  (interactive)
;;                  ( +workspace/switch-to 0 )
;;                  ))

;; (global-set-key (kbd "M-p") 'move-up-half)
;; (global-set-key (kbd "M-n") 'move-down-half)

(global-set-key (kbd "C-s") 'force-normal-n-save)

;; (global-set-key (kbd "M-p") 'move-up-half)
;; (global-set-key (kbd "M-n") 'move-down-half)
;; (define-key evil-normal-state-map (kbd ", SPC") 'recentf-open-most-recent-file-3)
(define-key evil-insert-state-map (kbd "M-SPC") 'surround-next-text)
(define-key evil-insert-state-map (kbd "M-;") 'yank)
;; (define-key evil-insert-state-map (kbd "M-o") 'insert-next-line)
;; (bind-key "C-x C-e" 'eval-current-line)
;; (unbind-key "C-x z")
;; (bind-key "C-x C-z" 'repeat)
;; (bind-key "C-x C-e" 'eval-current-line)


(map! :leader
      (:prefix ("v" . "misc")
        :desc "copy filename"          "f"  #'copy_file_name
        :desc "copy path"          "p"  #'xah-copy-file-path
        :desc ""                   "." #'dired-project-root
        :desc "goto function name" "a" #'gotofunname
        :desc "downlist"               "d"  #'down-list
        :desc ""               "o"  #'insert-next-line

        ;; :desc "uplist"                 "u"  #'backward-up-list
        ;; :desc "clip mon"            "c"  #'clipmon-autoinsert-toggle

        )
      )

;; (map!
;;  :m  "ze"    #'searchb4spaceorbracket
;;         )

(load "doom-themes-ext-org")
(load "doom-themes")
;; Load my theme
(setq doom-theme 'doom-dark+)
