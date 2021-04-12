;;; ~/.doom.d/mysetting/misc.el -*- lexical-binding: t; -*-

(defun gotofunname ()
  (interactive)
  (beginning-of-defun)
  ;; skip function in the case
  ;; export function fun(...) {}
  (search-forward "function")
  (if ( string-equal "(" (string (char-after)) )
      (evil-forward-word-begin 2)
    (evil-forward-word-begin 1)
    )
  (save-excursion
    (let ((oldpt ( point ))
          )
      (while (not (memq (char-after) '(?\t ?\n ?\s ?\( ?\) ?\] ?\[)))
        (evil-forward-char 1))
      (unless (> (point) oldpt)
        (backward-char 1)
        )
      (evil-yank oldpt  ( point ) )
      )
    )
  )

(defun YankFrom0 ()
  "replace the current word with text from register 0"
  (interactive)
  (kill-word 1)
  ;; 48 is the ascii code for char '0'
  (evil-paste-before nil 48)
  )

(defun searchb4spaceorbracket ()
  (interactive)
  (push-mark (point) nil t)
  (let ((oldpt ( point ))
        )
    ;; (while (not (eolp))
    (while (not (memq (char-after) '(?\t ?\n ?\s ?\( ?\) ?\] ?\[)))
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

(defun dired-project-root ()
  (interactive)
  (dired ( projectile-project-root ))
  )

(defun xah-copy-file-path (&optional @dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
Result is full path.
If `universal-argument' is called first, copy only the dir path.

If in dired, copy the file/dir cursor is on, or marked files.

If a buffer is not file and not dired, copy value of `default-directory' (which is usually the “current” dir when that buffer was created)

URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'
Version 2017-09-01"
  (interactive "P")
  (let (($fpath
         (if (string-equal major-mode 'dired-mode)
             (progn
               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))
                 (if (equal (length $result) 0)
                     (progn default-directory )
                   (progn $result))))
           (if (buffer-file-name)
               (buffer-file-name)
             (expand-file-name default-directory)))))
    (kill-new
     (if @dir-path-only-p
         (progn
           (message "Directory path copied: 「%s」" (file-name-directory $fpath))
           (file-name-directory $fpath))
       (progn
         (message "File path copied: 「%s」" $fpath)
         $fpath )))))
(defun copy_file_name ()
  "Copy the current file name to the kill ring."
  (interactive)
  (if-let* ((filename (or buffer-file-name (bound-and-true-p list-buffers-directory))))
      (message (kill-new (abbreviate-file-name ( file-name-nondirectory filename ))))
    (error "Couldn't find filename in current buffer")))

(map! :leader
      (:prefix ("v" . "misc")
        :desc "copy filename"          "f"  #'copy_file_name
        :desc "copy path"          "p"  #'xah-copy-file-path
        :desc ""                   "." #'dired-project-root
        :desc "goto function name" "a" #'gotofunname
        :desc "downlist"               "d"  #'down-list

        ;; :desc "uplist"                 "u"  #'backward-up-list
        ;; :desc "clip mon"            "c"  #'clipmon-autoinsert-toggle

        )
      )

;; (map!
;;  :m  "ze"    #'searchb4spaceorbracket
;;         )
