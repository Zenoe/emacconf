;;;
(setq url-proxy-services
      '(("no_proxy" . "localhost") ; Bypass proxy for localhost
        ("http" . "10.110.198.52:20171")
        ("https" . "10.110.198.52:20171")))

;; Set environment variables for proxy
(setenv "http_proxy" "http://10.110.198.52:20171")
(setenv "https_proxy" "http://10.110.198.52:20171")
(setq enable-local-variables :safe)
;;; key bindings
;;;
(defvar my-config-folder "~/.doom.d/emacconf")

;; List of all config files (without .el extension)
(defvar my-config-files
  '("customsetting"
    "buffer-nav"
    "project-nav"
    "quickedit"
    "super-save"
    "tmux-keymap"
    "window"
    "embark-config"
    "dap-config"
    "moreconfig"
    ;; "codeium"
    "treesitter"))

;; Load all files
(dolist (file my-config-files)
  (load (expand-file-name (concat file ".el") my-config-folder)))
;; (mapc 'load (file-expand-wildcards "~/.doom.d/emacconf/*.el"))
(setq confirm-kill-emacs nil)
;; var setting must come before mode setting t
;; if super-save-auto-save-when-idle were put after
;; (super-save-mode t), it would take no effect first time
;; emacs loaded
;; (setq super-save-auto-save-when-idle t)
;; when setting super-save-mode, it check variables to
;; do proper initialization
(super-save-mode t)
(setq auto-save-default nil)

;; (evil-mc-mode t)
;; (global-evil-mc-mode  1)

(nvmap "gb" 'sp-splice-sexp)
(nvmap "zv" 'selcurrentline)
(nvmap "z0" 'YankFrom0)
(nvmap "z;" 'selectBlock)
(nvmap "zs" 'surround-region-with-if)
(nvmap "g/" 'my/evil-search-clipboard)
(nvmap "zw" 'move-buffer-to-window)
(nvmap "zm" 'toggle-fold-indent)
(nvmap "ze" 'searchb4spaceorbracket)
(nvmap "z]" 'sgml-skip-tag-forward)
(nvmap "z'" 'selectHtmlTagBlock)
(nvmap "z[" 'sgml-skip-tag-backward)
(nvmap "zp" 'yank-and-indent)
;; (nvmap "zy" 'my-evil-paste-after-and-delete)
(nvmap "go" 'comment-line)
(nvmap "[e" 'flycheck-previous-error)
(nvmap "]e" 'flycheck-next-error)
(nvmap "zg" 'isearch-forward-region)
(nvmap "gp" 'my/evil-select-pasted)
(nvmap "[z" 'my/flip-symbol)

;; dumb-jump is much faster then xref-definition, don't know why
(setq +lookup-definition-functions
  '(+lookup-dumb-jump-backend-fn
    +lookup-xref-definitions-backend-fn
    +lookup-project-search-backend-fn
    +lookup-evil-goto-definition-backend-fn)
)

(global-set-key (kbd "C-x C-n") 'replace-matching-paren)
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
        :desc "copy path"          "p"  #'copy-file-path-to-clipboard
        :desc ""                   "." #'dired-project-root
        :desc "goto function name" "a" #'get-function-name
        :desc "downlist"               "d"  #'down-list
        :desc "uplist"               "u"  #'up-list
        :desc ""               "o"  #'insert-next-line
        :desc ""                "j" #'projectile-find-file-dwim
        :desc ""                "r" #'replace-buffer-with-clipboard
        :desc ""                "k" #'my/search-js-functions-and-generate-import

        ;; :desc "uplist"                 "u"  #'backward-up-list
        ;; :desc "clip mon"            "c"  #'clipmon-autoinsert-toggle

        )
      )

;; C-M-u： backward-up-list
;; (map!
;;  :m  "ze"    #'searchb4spaceorbracket
;;         )

;; Customize the face for word being search in evil
(custom-set-faces
 '(evil-ex-lazy-highlight ((t (:background "#f4f4f4" :foreground "#FD79FF"))))
 '(company-tooltip-selection ((t (:background "#f4f4f4" :foreground "#FD7F00"))))
 )

;; tmux would change ctrl shift arrow key binding to as follows
;; (global-set-key "\M-[1;6n" 'windmove-up)

(require 'prettier-js)
(setq-hook! 'js-mode-hook +format-with-lsp nil)
(setq-hook! 'js-mode-hook +format-with :none)
(add-hook 'js-mode-hook 'prettier-js-mode)


(require 'vertico)
;; (custom-set-faces
;;  '(vertico-current ((t (:foreground "#839496" :background "#D02B36" :weight bold))))
;;  )

;; (use-package! lsp-tailwindcss)
;; (use-package! lsp-tailwindcss :init (setq! lsp-tailwindcss-experimental-class-regex ["tw`([^`]*)" "tw=\"([^\"]*)" "tw={\"([^\"}]*)" "tw\\.\\w+`([^`]*)" "tw\\(.*?\\)`([^`]*)"]) (setq! lsp-tailwindcss-add-on-mode t))

;; org mode
;;
(after! org
  (define-key org-mode-map (kbd "C-c o") 'org-insert-subheading))

;; Or you can create a custom function to insert a new headline at the same level
;; (defun my/org-insert-heading-same-level ()
;;   (interactive)
;;   (org-insert-heading)
;;   (outline-demote))

;; ;; Bind the custom function to a key combination
;; (after! org
;;   (define-key org-mode-map (kbd "C-c N") 'my/org-insert-heading-same-level))

;;(multiple-cursors-mode nil)
;;(global-evil-mc-mode  1)
;; fix gibberish (messy code) when copy Chinese from another place
(when (eq system-type 'windows-nt)  (set-next-selection-coding-system 'utf-16-le)  (set-selection-coding-system 'utf-16-le)  (set-clipboard-coding-system 'utf-16-le))(when (eq system-type 'windows-nt)  (set-next-selection-coding-system 'utf-16-le)  (set-selection-coding-system 'utf-16-le)  (set-clipboard-coding-system 'utf-16-le))
