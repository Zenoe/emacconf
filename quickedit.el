;;https://www.emacswiki.org/emacs/AutoIndentation
;;Auto-indent yanked (pasted) code
;; (dolist (command '(yank yank-pop))
;;    (eval `(defadvice ,command (after indent-region activate)
;;             (and (not current-prefix-arg)
;;                  (member major-mode '(emacs-lisp-mode lisp-mode
;;                                                       javascript-mode    typescript-mode
;;                                                       clojure-mode    scheme-mode
;;                                                       haskell-mode    ruby-mode
;;                                                       rspec-mode      python-mode
;;                                                       c-mode          c++-mode
;;                                                       objc-mode       latex-mode
;;                                                       plain-tex-mode))
;;                  (let ((mark-even-if-inactive transient-mark-mode))
;;                    (indent-region (region-beginning) (region-end) nil))))))

(defun my-evil-paste-after-and-delete ()
  "paste to replace without modifing kill ring"
  (interactive)
  (let ((text-to-paste (car kill-ring)))
    (message text-to-paste)
    (delete-region (region-beginning) (region-end))
    (insert text-to-paste)
    ))

(defun current-line-empty-p ()
  (message "icurrent-line-empty-p")
  (string-match-p "\\`\\s-*$" (thing-at-point 'line)))

;; (defun current-line-empty-p ()
;;   (message "current-line-empty-p")
;;   (save-excursion
;;     (beginning-of-line)
;;     (looking-at-p "[[:space:]]*$")))

(defun yank-and-indent ()
  "Yank and then indent the newly formed region according to mode."
  (interactive)
  (unless ( current-line-empty-p )
          (evil-open-below 1)
          )
  (yank)
  (evil-force-normal-state)
  (call-interactively 'indent-region))

(defun cancel-selection ()
  (interactive)
  (exchange-point-and-mark )
  (evil-normal-state)
  )

(defun selectBlock ()
  (interactive)
  (evil-visual-char)
  (evil-beginning-of-line)
  (exchange-point-and-mark)
  (evil-last-non-blank)
  (evil-jump-item)
  (evil-end-of-line)
  (evil-yank  (region-end) (region-beginning))
  ;; (evil-force-normal-state)
  )

(defun gotoLastChange ()
  (interactive)
  (goto-last-change 1)
  (what-line)
  (evil-scroll-line-to-center (line-number-at-pos))
  )

(defun selcurrentline ()
  ;;; select current line.
  ;;; will change curosr's position
  (interactive)
     (evil-first-non-blank)
     (evil-visual-char)
     (evil-end-of-line)
     (evil-yank (region-beginning) (region-end))
     (evil-force-normal-state)
   )

;; (defun was-yanked ()
;;   "When called after a yank, store last yanked value in let-bound yanked."
;;   "http://stackoverflow.com/questions/22960031/save-yanked-text-to-string-in-emacs "
;;   (interactive)
;;   (let (yanked)
;;     (and (eq last-command 'yank)
;;          (setq yanked (car kill-ring)))))

;;http://emacs.stackexchange.com/questions/14553/how-call-the-eval-sexp-function-with-the-right-argument
(defun eval-current-line (arg)
  (interactive "P")
  (evil-set-marker ?8) ;;The number 8 is just abritrary
  (line-end-position)
  ;; (sp-end-of-sexp)
  (eval-last-sexp arg)
  (evil-goto-mark ?8))

(defun surround-next-text ()
  (interactive)
  (insert "(")
  (move-end-of-line 1)
  (insert ")")
  )

(defun trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
(replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string))
)

(defun force-normal-n-save ()
  (interactive)
(evil-force-normal-state)
(save-buffer)
  )

(defun insert-next-line ()
  ;; go to next line to edit especially in insert state
  ;; no continuation of comments
  ;; (setq +evil-want-o/O-to-continue-comments nil)
  (interactive)
  (evil-end-of-line)
  (evil-open-below 1)
  )
;; (defun set-selective-display-dlw (&optional level)
;; "Fold text indented same of more than the cursor.
;; If level is set, set the indent level to LEVEL.
;; If 'selective-display' is already set to LEVEL, clicking
;; F5 again will unset 'selective-display' by setting it to 0."
;;   (interactive "P")
;;   (if (eq selective-display (1+ (current-column)))
;;       (set-selective-display 0)
;;     (set-selective-display (or level (1+ (current-column))))))


;; buffer
(defun switch-to-scratch-buffer ()
  "Switch to the `*scratch*' buffer. Create it first if needed."
  (interactive)
  (let ((exists (get-buffer "*scratch*")))
    (switch-to-buffer (get-buffer-create "*scratch*"))
    ))

(defun move-buffer-to-window ()
  (interactive)
  (set-window-buffer (next-window ) (buffer-name))
  (evil-switch-to-windows-last-buffer)
  )


;; https://emacs.stackexchange.com/questions/37634/how-to-replace-matching-parentheses
(defun yf/replace-pair (open close)
  "Replace pair at point by respective chars OPEN and CLOSE.
If CLOSE is nil, lookup the syntax table. If that fails, signal
an error."
  (let ((close (or close
                   (cdr-safe (aref (syntax-table) open))
                   (error "No matching closing char for character %s (#%d)"
                          (single-key-description open t)
                          open)))
        (parens-require-spaces))
    (insert-pair 1 open close))
  (delete-pair)
  (backward-char 1))

(defun yf/replace-or-delete-pair (open)
  "Replace pair at point by OPEN and its corresponding closing character.
The closing character is lookup in the syntax table or asked to
the user if not found."
  (interactive
   (list
    (read-char
     (format "Replacing pair %c%c by (or hit RET to delete pair):"
             (char-after)
             (save-excursion
               (forward-sexp 1)
               (char-before))))))
  (if (memq open '(?\n ?\r))
      (delete-pair)
    (let ((close (cdr (aref (syntax-table) open))))
      (when (not close)
        (setq close
              (read-char
               (format "Don't know how to close character %s (#%d) ; please provide a closing character: "
                       (single-key-description open 'no-angles)
                       open))))
      (yf/replace-pair open close))))


;; C-x n n
;; C-s sometext
;; C-x n w

(defun isearch-forward-region-cleanup ()
  "turn off variable, widen"
  (if isearch-forward-region
      (widen))
  (setq isearch-forward-region nil))

(defvar isearch-forward-region nil
  "variable used to indicate we're in region search")

(add-hook 'isearch-mode-end-hook 'isearch-forward-region-cleanup)

(defun isearch-forward-region (&optional regexp-p no-recursive-edit)
  "Do an isearch-forward, but narrow to region first."
  (interactive "P\np")
  (narrow-to-region (point) (mark))
  (goto-char (point-min))
  (setq isearch-forward-region t)
  (isearch-mode t (not (null regexp-p)) nil (not no-recursive-edit)))

(defun my/evil-select-pasted ()
  (interactive)
  (let ((start-marker (evil-get-marker ?\[))
        (end-marker (evil-get-marker ?\])))
        (evil-visual-select start-marker end-marker)))

(require 'dash)
(defvar my-flip-symbol-alist
  '(("true" . "false")
    ("false" . "true"))
  "symbols to be quick flipped when editing")

(defun my/flip-symbol ()
  "\"I don't want to type here, just do it for me.\""
  (interactive)
  (-let* (((beg . end) (bounds-of-thing-at-point 'symbol))
          (sym (buffer-substring-no-properties beg end)))
    (when (member sym (cl-loop for cell in my-flip-symbol-alist
                               collect (car cell)))
      (delete-region beg end)
      (insert (alist-get sym my-flip-symbol-alist "" nil 'equal)))))

;; (defun evil-select-pasted ()
;;   "Visually select last pasted text."
;;   (interactive)
;;   (evil-goto-mark ?\[)
;;   (evil-visual-char)
;;   (evil-goto-mark ?\]))
(set-popup-rule! "^\\*Async Shell Command" :vslot 1 :ttl nil)
;; (set-popup-rule! "^\\*Async Shell Command" :size 0.3 :ttl nil :select t)

; ?\{ is the Emacs Lisp notation for the character {
(defun replace-matching-paren (new-op)
  "Replace the current operator under the cursor with NEW-OP and its matching pair."
  (interactive "cEnter the new operator: ")
  (let* ((current-char (char-after (point)))
         (new-close-op (cond
                        ((equal new-op ?\{) ?\})
                        ((equal new-op ?\[) ?\])
                        ((equal new-op ?\<) ?\>)
                        ((equal new-op ?\() ?\))
                        ((equal new-op ?\") ?\")
                        ((equal new-op ?\') ?\')
                        (t new-op)))
         (current-pair (cond
                        ((equal current-char ?\{) '(?\{ . ?\}))
                        ((equal current-char ?\[) '(?\[ . ?\]))
                        ((equal current-char ?\<) '(?\< . ?\>))
                        ((equal current-char ?\() '(?\( . ?\)))
                        ((equal current-char ?\") '(?\" . ?\"))
                        ((equal current-char ?\') '(?\' . ?\'))
                        (t nil))))
    (if current-pair
        (let ((current-open (car current-pair))
              (current-close (cdr current-pair))
              (pos (point)))
          (save-excursion
            ;; Find and replace the closing operator
            (let ((current-char (char-after)))
              (cond
               ((member current-char '(?\( ?\{ ?\[)) (evil-jump-item)  ;; Jump to the matching operator
                (if (equal (char-after (point)) current-close)
                    (progn
                      (delete-char 1)
                      (insert (char-to-string new-close-op)))
                  (error "Matching closing operator not found")))
               (t
                ;; (message "xxxx %s" (char-to-string current-close))
                (forward-char 1)
                (if (search-forward (char-to-string current-close) nil t)
                    (progn
                      (backward-delete-char 1)
                      (insert (char-to-string new-close-op)))
                  (error "Matching closing operator not found"))
                )))
            )
          ;; Replace the opening operator
          (if (equal (char-after pos) current-open)
              (progn
                (delete-char 1)
                (insert (char-to-string new-op)))
            (error "Cursor is not on an operator %s" (char-to-string (char-after pos))))
          )
      )))
