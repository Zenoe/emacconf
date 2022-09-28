;;; ~/.doom.d/mysetting/customSetting.el -*- lexical-binding: t; -*-



(general-evil-setup t)
(when (require 'xclip nil 'noerror)
  (xclip-mode 1))

;;(require 'helm)
;;(set-face-attribute 'helm-selection nil :background "#EFFFE0" :foreground "black")

;; cygwin theme: 'gruvbox'
;; doom theme: 'dark+'
;; (set-face-attribute 'region nil :background "#105000" :foreground "#FE90D8" )
;;(require 'swiper)
;;(set-face-attribute 'swiper-line-face nil :background "blue" :foreground "white")
;;(set-face-attribute 'swiper-match-face-1 nil :background "#101010" :foreground "orange")

;; in variable: doom-themes--faces
;; has (evil-search-highlight-persist-highlight-face :inherit 'lazy-highlight)
;; (set-face-attribute 'lazy-highlight nil :foreground "black" :background "white")

;; (custom-set-faces
;;  '(link ((t (:foreground "#570057"))))
;;  )

;; (require 'hl-line)
;; (set-face-attribute 'hl-line nil :background "#80f28B")
;; (set-face-background hl-line-face "#A0B3B5")

;; (setq dired-dwim-target t)

;; hooks
;; (add-hook 'go-mode-hook '+company/toggle-auto-completion)
;; typescript
;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . js-jsx-mode))
;; (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))


;; (setq typescript-indent-level 2)
;; (setq js-indent-level 2);; not work
(add-hook 'js2-mode-hook (lambda () (setq js-indent-level 2)))
(add-hook 'js2-mode-hook (lambda () (setq super-save-auto-save-when-idle nil)))
(add-hook 'js2-mode-hook 'eslintd-fix-mode)
;; Emacs comes with hs-minor-mode which can be used selectively hide/show code and comment blocks in several languages,
;; including JavaScript. By default this will let you hide and show JSON blocks delimited by '{' and '}' but it is easily
;; modified to allow '[' and ']' as block delimeters as well. To do this we need to modify the js-mode entry in hs-special-modes-alist with something like:
(add-hook 'js2-mode-hook (lambda () (setcdr (assoc 'js-mode hs-special-modes-alist) '("[{[]" "[}\\]]" "/[*/]" nil))))
;;
;; (setq evil-ex-search-case 'sensitive)
;; (add-to-list 'projectile-globally-ignored-files '("yarn.lock" "node_modules"))
;; (global-auto-complete-mode t)
;;
(require 'company)
;; remove a key from a minor-mode keymap
(define-key company-active-map (kbd "C-n") 'nil)
(define-key company-active-map (kbd "C-p") 'nil)
(define-key company-search-map (kbd "C-n") 'nil)
(define-key company-search-map (kbd "C-p") 'nil)

(define-key company-active-map (kbd "M-[") 'company-select-next)
(define-key company-active-map (kbd "M-]") 'company-select-previous)
(define-key company-search-map (kbd "M-[") 'company-select-next)
(define-key company-search-map (kbd "M-]") 'company-select-previous)

(global-set-key (kbd "C-<down>") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<up>") 'mc/mark-previous-like-this)
;; (setq xref-js2-search-program 'ag)

