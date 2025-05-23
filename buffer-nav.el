;;; ~/.doom.d/mysetting/misc.el -*- lexical-binding: t; -*-

(defun YankFrom0 ()
  "replace the current word with text from register 0"
  (interactive)
  ;; (kill-word 1)
  ;; 48 is the ascii code for char '0'
  (evil-paste-after nil 48)
  )

(defun searchb4spaceorbracket ()
  (interactive)
  (push-mark (point) nil t)
  (let ((oldpt ( point ))
        )
    ;; (while (not (eolp))
    (while (not (memq (char-after) '(?\t ?\n ?\s ?\( ?\) ?\] ?\[ ?\, ?\; ?\. ?\: ?\" ?\')))
      (evil-forward-char 1))

    ;; (message "%d, %d" oldpt (point))
    (if (> (point) oldpt)
        (backward-char 1)
      t
      )
    (if (= (point) oldpt)
        (deactivate-mark)
      t
      )
    (evil-yank oldpt  (+( point ) 1) )
    (keyboard-quit)
    )
  )

(defun joaot/delete-process-at-point()
  (interactive)
  (let ((process (get-text-property (point) 'tabulated-list-id)))
    (cond ((and process
                (processp process))
           (delete-process process)
           (revert-buffer))
          (t
           (error "no process at point!")))))
(defun move-up-half ()
  (interactive)
  (setq first-line (window-start (selected-window)))
  (move-to-window-line  ( / (count-lines ( point )  first-line ) 2 ) )
  )

(defun move-down-half ()
  (interactive)
  (setq last-line (window-end (selected-window)))
  (move-to-window-line  (- ( / (count-lines ( point )  last-line ) 2 ) ))
  )

(defun tag-word-or-region (tag)
    "Surround current word or region with a given tag."
    (interactive "sEnter tag (without <>): ")
    (let (bds start-tag end-tag)
    (setq start-tag (concat "<" tag ">"))
    (setq end-tag (concat "</" tag ">"))
    (if (and transient-mark-mode mark-active)
        (progn
            (goto-char (region-end))
            (insert end-tag)
            (goto-char (region-beginning))
            (insert start-tag))
        (progn
            (setq bds (bounds-of-thing-at-point 'symbol))
            (goto-char (cdr bds))
            (insert end-tag)
            (goto-char (car bds))
            (insert start-tag)))))

;; evil-ex-make-search-pattern builds a pattern object from the clipboard text.
;; evil-ex-search-activate-highlight ensures highlighting works like a normal / search.
;; evil-ex-search-next actually jumps to the first match.
;; Sets direction to 'forward like pressing /.
(defun my/evil-search-clipboard ()
  "Search forward using Evil with the current system clipboard contents."
  (interactive)
  (let ((clipboard-text (current-kill 0)))
    (when (and clipboard-text (not (string-empty-p clipboard-text)))
      (setq evil-ex-search-direction 'forward)
      (setq evil-ex-search-pattern (evil-ex-make-search-pattern clipboard-text))
      (evil-ex-search-activate-highlight evil-ex-search-pattern)
      (evil-ex-search-next))))

(defun surround-region-with-if (tag)
    "Surround region with if/when statement."
    (interactive "sEnter if/when/: ")
    ;; (unless tag (setq tag "if"))
    ;; default to be if
    (if (= (length tag) 0)
        (setq tag "if"))
    (let (bds start-tag end-tag)
    (setq start-tag (concat tag "(){\n"))
    (setq end-tag (concat "\n}"))
    (if (and transient-mark-mode mark-active)
        (progn
            (goto-char (region-end))
            (insert end-tag)
            (goto-char (region-beginning))
            (insert start-tag))
        (progn
            (setq bds (bounds-of-thing-at-point 'symbol))
            (goto-char (cdr bds))
            (insert end-tag)
            (goto-char (car bds))
            (insert start-tag))))
    (goto-char (region-beginning))
    (search-forward "(")
    (evil-insert-state)
    )


(defun copy_file_name ()
  "Copy the current file name to the kill ring."
  (interactive)
  (if-let* ((filename (or buffer-file-name (bound-and-true-p list-buffers-directory))))
      (message (kill-new (abbreviate-file-name ( file-name-nondirectory filename ))))
    (error "Couldn't find filename in current buffer")))

(defun copy-file-path-to-clipboard ()
  "Copy the current buffer file path to the clipboard."
  (interactive)
  (if (buffer-file-name)
      (let ((file-path (buffer-file-name)))
        (kill-new file-path)
        (message "Copied file path to clipboard: %s" file-path))
    (message "Buffer is not visiting a file")))
