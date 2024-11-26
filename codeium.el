;;; emacconf/codeium.el -*- lexical-binding: t; -*-
(setq copilot-network-proxy '(:host "10.110.198.50" :port 11435 :rejectUnauthorized :json-false))

;; (defun copilot-complete ()
;;   (interactive)
;;   (let* ((spot (point))
;;          (inhibit-quit t)
;;          (curfile (buffer-file-name))
;;          (cash (concat curfile ".cache"))
;;          (hist (concat curfile ".prompt"))
;;          (lang (file-name-extension curfile))

;;          ;; extract current line, to left of caret
;;          ;; and the previous line, to give the llm
;;          (code (save-excursion
;;                  (dotimes (i 2)
;;                    (when (> (line-number-at-pos) 1)
;;                      (previous-line)))
;;                  (beginning-of-line)
;;                  (buffer-substring-no-properties (point) spot)))

;;          ;; create new prompt for this interaction
;;          (system "\
;; You are an Emacs code generator. \
;; Writing comments is forbidden. \
;; Writing test code is forbidden. \
;; Writing English explanations is forbidden. ")
;;          (prompt (format
;;                   "[INST]%sGenerate %s code to complete:[/INST]\n```%s\n%s"
;;                   (if (file-exists-p cash) "" system) lang lang code)))

;;     ;; iterate text deleted within editor then purge it from prompt
;;     (when kill-ring
;;       (save-current-buffer
;;         (find-file hist)
;;         (dotimes (i 10)
;;           (let ((substring (current-kill i t)))
;;             (when (and substring (string-match-p "\n.*\n" substring))
;;               (goto-char (point-min))
;;               (while (search-forward substring nil t)
;;                 (delete-region (- (point) (length substring)) (point))))))
;;         (save-buffer 0)
;;         (kill-buffer (current-buffer))))

;;     ;; append prompt for current interaction to the big old prompt
;;     (write-region prompt nil hist 'append 'silent)

;;     ;; run llamafile streaming stdout into buffer catching ctrl-g
;;     (with-local-quit
;;       (call-process "~/.doom.d/wizardcoder-python-13b.llamafile"
;;                     nil (list (current-buffer) nil) t
;;                     "--prompt-cache" cash
;;                     "--prompt-cache-all"
;;                     "--silent-prompt"
;;                     "--temp" "0"
;;                     "-c" "1024"
;;                     "-ngl" "35"
;;                     "-r" "```"
;;                     "-r" "\n}"
;;                     "-f" hist))

;;     ;; get rid of most markdown syntax
;;     (let ((end (point)))
;;       (save-excursion
;;         (goto-char spot)
;;         (while (search-forward "\\_" end t)
;;           (backward-char)
;;           (delete-backward-char 1 nil)
;;           (setq end (- end 1)))
;;         (goto-char spot)
;;         (while (search-forward "```" end t)
;;           (delete-backward-char 3 nil)
;;           (setq end (- end 3))))

;;       ;; append generated code to prompt
;;       (write-region spot end hist 'append 'silent))))

;; (use-package codeium
;;     ;; if you use straight
;;     ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
;;     ;; otherwise, make sure that the codeium.el file is on load-path

;;     :init
;;     ;; use globally
;;     (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;;     ;; or on a hook
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))

;;     ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local completion-at-point-functions
;;     ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
;;     ;; an async company-backend is coming soon!

;;     ;; codeium-completion-at-point is autoloaded, but you can
;;     ;; optionally set a timer, which might speed up things as the
;;     ;; codeium local language server takes ~0.2s to start up
;;     ;; (add-hook 'emacs-startup-hook
;;     ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

;;     ;; :defer t ;; lazy loading, if you want
;;     :config
;;     (setq use-dialog-box nil) ;; do not use popup boxes

;;     ;; if you don't want to use customize to save the api-key
;;     ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

;;     ;; get codeium status in the modeline
;;     (setq codeium-mode-line-enable
;;         (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
;;     (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
;;     ;; alternatively for a more extensive mode-line
;;     ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

;;     ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
;;     (setq codeium-api-enabled
;;         (lambda (api)
;;             (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
;;     ;; you can also set a config for a single buffer like this:
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local codeium/editor_options/tab_size 4)))

;;     ;; You can overwrite all the codeium configs!
;;     ;; for example, we recommend limiting the string sent to codeium for better performance
;;     (defun my-codeium/document/text ()
;;         (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
;;     ;; if you change the text, you should also change the cursor_offset
;;     ;; warning: this is measured by UTF-8 encoded bytes
;;     (defun my-codeium/document/cursor_offset ()
;;         (codeium-utf8-byte-length
;;             (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
;;     (setq codeium/document/text 'my-codeium/document/text)
;;     (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))
;; ;; (use-package company
;; ;;     :defer 0.1
;; ;;     :config
;; ;;     (global-company-mode t)
;; ;;     (setq-default
;; ;;         company-idle-delay 0.05
;; ;;         company-require-match nil
;; ;;         company-minimum-prefix-length 0

;; ;;         ;; get only preview
;; ;;         company-frontends '(company-preview-frontend)
;; ;;         ;; also get a drop down
;; ;;         ;; company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
;; ;;         ))
