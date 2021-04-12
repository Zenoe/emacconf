;;; ~/.doom.d/mysetting/customSetting.el -*- lexical-binding: t; -*-



(general-evil-setup t)
(when (require 'xclip nil 'noerror)
  (xclip-mode 1))

;;(require 'helm)
;;(set-face-attribute 'helm-selection nil :background "#EFFFE0" :foreground "black")

;; (set-face-attribute 'region nil :background "#909090" :foreground "#DD00D8" )
;; (set-face-attribute 'lazy-highlight nil :foreground "red" :background "black")

(custom-set-faces
 '(link ((t (:foreground "#570057"))))
 )

;; (require 'hl-line)
;; (set-face-attribute 'hl-line nil :background "#80f28B")
;; (set-face-background hl-line-face "#A0B3B5")

(setq dired-dwim-target t)

;; hooks
;; (add-hook 'go-mode-hook '+company/toggle-auto-completion)
;; typescript
;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . js-jsx-mode))
;; (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(setq typescript-indent-level 2)

;; (setq js-indent-level 2);; not work
(add-hook 'js2-mode-hook (lambda () (setq js-indent-level 2)))
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
