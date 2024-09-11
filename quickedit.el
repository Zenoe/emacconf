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

(defun selectHtmlTagBlock ()
  (interactive)
  (evil-visual-line)
  (sgml-skip-tag-forward 1)
  (evil-yank  (region-end) (region-beginning))
  )
;;
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
    ("false" . "true")
    ("let" . "const")
    ("const" . "let")
    )
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


;; "evil-nerd-commenter has bug with rjsx-mode"
;; uncomment will remove all // in a line
(setq rjsx-comment-start-skip "[[:space:]]*\\(?://+\\|{?/\\*+\\)")
(defun +comment-search-forward (limit &optional noerror)
  "Find a comment start between point and LIMIT.
Moves point to inside the comment and returns the position of the
comment-starter.  If no comment is found, moves point to LIMIT
and raises an error or returns nil if NOERROR is non-nil.

Ensure that `comment-normalize-vars' has been called before you use this."
  (if (not comment-use-syntax)
      (if (re-search-forward rjsx-comment-start-skip limit noerror)
	  (or (match-end 1) (match-beginning 0))
	(goto-char limit)
	(unless noerror (error "No comment")))
    (let* ((pt (point))
	   ;; Assume (at first) that pt is outside of any string.
	   (s (parse-partial-sexp pt (or limit (point-max)) nil nil
				  (if comment-use-global-state (syntax-ppss pt))
				  t)))
      (when (and (nth 8 s) (nth 3 s) (not comment-use-global-state))
	;; The search ended at eol inside a string.  Try to see if it
	;; works better when we assume that pt is inside a string.
	(setq s (parse-partial-sexp
		 pt (or limit (point-max)) nil nil
		 (list nil nil nil (nth 3 s) nil nil nil nil)
		 t)))
      (if (or (not (and (nth 8 s) (not (nth 3 s))))
	      ;; Make sure the comment starts after PT.
	      (< (nth 8 s) pt))
	  (unless noerror (error "No comment"))
	;; We found the comment.
	(let ((pos (point))
	      (start (nth 8 s))
	      (bol (line-beginning-position))
	      (end nil))
	  (while (and (null end) (>= (point) bol))
	    (if (looking-at rjsx-comment-start-skip)
		(setq end (min (or limit (point-max)) (match-end 0)))
	      (backward-char)))
	  (goto-char (or end pos))
	  start)))))

(defun +comment-forward (&optional n)
  "Skip forward over N comments.
Just like `forward-comment` but only for positive N and can use regexps instead of syntax."
  (setq n (or n 1))
  (if (< n 0) (error "No comment-backward")
    (if comment-use-syntax (forward-comment n)
      (while (> n 0)
        (setq n
              (if (or (forward-comment 1)
                      (and (looking-at rjsx-comment-start-skip)
                           (goto-char (match-end 0))
                           (re-search-forward comment-end-skip nil 'move)))
                  (1- n) -1)))
      (= n 0))))

(defadvice! +rjsx-uncomment-region-function (beg end &optional _)
  :override #'rjsx-uncomment-region-function
  (js2-mode-wait-for-parse
   (lambda ()
     (goto-char beg)
     (setq end (copy-marker end))
     (let (cs ts te ce matched-start)
       ;; find comment start
       (while (and (<= (point) end)
                   (setq ipt (point))
                   (setq spt (+comment-search-forward end t)))
         (let ((ept (progn
                      (goto-char spt)
                      (unless (or (+comment-forward)
                                  (eobp))
                        (error "Can't find the comment end"))
                      (point))))
           (save-restriction
             (narrow-to-region spt ept)
             ;; delete comment-start
             (goto-char ipt)
             (setq matched-start
                   (and (re-search-forward comment-start-skip end t 1)
                        (match-string-no-properties 0)))
             (setq cs (match-beginning 1))
             (setq ts (match-end 1))
             (goto-char cs)
             (delete-region cs ts)

             ;; delete comment-padding start
             (when (and comment-padding (looking-at (regexp-quote comment-padding)))
               (delete-region (point) (+ (point) (length comment-padding))))

             ;; find comment end
             (when (re-search-forward (if (string-match "//+" matched-start) "\n" "\\*/}?") end t 1)
               (setq te (or (match-beginning 1) (match-beginning 0)))
               (setq ce (or (match-end 1) (match-end 0)))
               (goto-char te)

               ;; delete commend-end if it's not a newline
               (unless (string= "\n" (match-string-no-properties 0))
                 (delete-region te ce)

                 ;; delete comment-padding end
                 (when comment-padding
                   (backward-char (length comment-padding))
                   (when (looking-at (regexp-quote comment-padding))
                     (delete-region (point) (+ (point) (length comment-padding))))))

               ;; unescape inner comments if any
               (save-restriction
                 (narrow-to-region cs (point))
                 (comment-quote-nested "{/*" "*/}" t)))
             (goto-char (point-max))))

         ))

     (rjsx-maybe-unwrap-expr beg end)

     (set-marker end nil))))

(defun is-js-function-start (line)
  "Check if LINE is the start of a function in JavaScript, including the last '{'."
  (or (string-match-p "^\s*function\s*[a-zA-Z_$]+\(.*\)\s*{" line)  ; Matches 'function name(...) {'
      (string-match-p "^\s*.* => {" line)
      )
  )

(defun line-ends-with-paren-or-brace-p ()
  "Return t if the current line ends with '(' or '{', otherwise nil."
  (save-excursion
    (end-of-line)
    (let ((char-before (char-before)))
      (or (eq char-before ?\() (eq char-before ?\{)))))

(defun toggle-fold-indent ()
  "Toggle code folding according to indentation of current line."
  (interactive)
   (let* ((current-indent (current-indentation))
         (line-number (line-number-at-pos))
         ;; (matching-lines '())
         )
    (save-excursion
      ;; Check the lines below the current line
      (while (not (eobp))
        (let ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
          (when (and (= (current-indentation) current-indent)
                     (or ( line-ends-with-paren-or-brace-p ) (is-js-function-start line)))
            ;; (push (line-number-at-pos) matching-lines)
            (+fold/toggle)
            ))
        (forward-line 1)))
    ;; Check the lines above the current line
    (save-excursion
      (goto-char (point-min))
      (while (< (line-number-at-pos) line-number)
        (let ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
          (when (and (= (current-indentation) current-indent)
                     (is-js-function-start line))
            (+fold/close)
            ;; (push (line-number-at-pos) matching-lines)
            ))
        (forward-line 1)))
    ;; Print the matching line numbers
    ;; (if matching-lines
    ;;     (message "Lines with same indent: %s" (mapconcat 'number-to-string (nreverse matching-lines) ", "))
    ;;   (message "No lines with the same indent found."))
      )
  ;; (set-selective-display
  ;;  (if selective-display
  ;;      nil
  ;;    (save-excursion
  ;;      (back-to-indentation)
  ;;      (1+ (current-column)))))
  )
;; (defun extract-javascript-function-names ()
;;   "Extract JavaScript function names from the current buffer and display them."
;;   (interactive)
;;   (let ((function-names '())
;;         (patterns '(
;;                     "const \\([a-zA-Z0-9_$]+\\) *= *([^)]*) *=> *{"
;;                     "const \\([a-zA-Z0-9_$]+\\) *= *() *=> *{"
;;                     "const \\([a-zA-Z0-9_$]+\\) *= *[^ ]* *=> *{"
;;                     "export function \\([a-zA-Z0-9_$]+\\) *([^)]*) *{"
;;                     "export function \\([a-zA-Z0-9_$]+\\) *() *{"
;;                     )))
;;     (save-excursion
;;       (goto-char (point-min))
;;       (dolist (pattern patterns)
;;         (while (re-search-forward pattern nil t)
;;           (let ((name (match-string 1)))
;;             (when name
;;               (push name function-names))))))
;;     (if function-names
;;         (message "JavaScript function names: %s" (string-join (reverse function-names) ", "))
;;       (message "No function names found."))))

(defun get-function-name ()
  (interactive)
  (beginning-of-defun)
  (let* ((line (thing-at-point 'line t))
         (patterns '(
                     "const \\([a-zA-Z0-9_$]+\\) *= *([^)]*) *=> *{"
                     "const \\([a-zA-Z0-9_$]+\\) *= *() *=> *{"
                     "const \\([a-zA-Z0-9_$]+\\) *= *[^ ]* *=> *{"
                     "function \\([a-zA-Z0-9_$]+\\) *([^)]*) *{"
                     "function \\([a-zA-Z0-9_$]+\\) *() *{"
                     "export function \\([a-zA-Z0-9_$]+\\) *([^)]*) *{"
                     "export function \\([a-zA-Z0-9_$]+\\) *() *{"
                     ))
         found-name)
    (when line
      (dolist (pattern patterns)
        (when (string-match pattern line)
          (setq found-name (match-string 1 line)))))
    (if found-name
        (progn
          ;; (evil-set-register ?/ found-name)  ;; Copy the found name to the / register
          (message "Function name: %s" found-name)
          (setq string
                (format "\\_<%s\\_>"
                        (regexp-quote found-name)))
          ;; (push string evil-ex-search-history)
          (evil-push-search-history string 'forward)
          (evil-search string 'forward t)
          ;; (setq evil-ex-search-pattern found-name)
          ;; n: evil-ex-search-next, get the search content from evil-ex-search-pattern
          ;; not from the / register
          (setq evil-ex-search-pattern (evil-ex-make-search-pattern string))
          ;; (evil-search string 'forward t)
          )
      (message "No function name found on the current line."))))

;; (evil-set-register ?/ "\\_<defun\\_>")
;; (evil-set-register ?/ nil)

;; reference
;; (defun evil-search-word (forward unbounded symbol)
;;   "Search for word near point.
;; If FORWARD is nil, search backward, otherwise forward. If SYMBOL
;; is non-nil then the functions searches for the symbol at point,
;; otherwise for the word at point."
;;   (let ((string (car regexp-search-ring)))
;;     (setq isearch-forward forward)
;;     (cond
;;      ((and (memq last-command
;;                  '(evil-search-word-forward
;;                    evil-search-word-backward))
;;            (stringp string)
;;            (not (string= string "")))
;;       (evil-search string forward t))
;;      (t
;;       (setq string (evil-find-thing forward (if symbol 'symbol 'evil-word)))
;;       (cond
;;        ((null string)
;;         (user-error "No word under point"))
;;        (unbounded
;;         (setq string (regexp-quote string)))
;;        (t
;;         (setq string
;;               (format (if symbol "\\_<%s\\_>" "\\<%s\\>")
;;                       (regexp-quote string)))))
;;       (evil-push-search-history string forward)
;;       (evil-search string forward t)))))
