(use-package tree-sitter
  :ensure t
  :defer t
  :diminish " tree"
  :hook ((zig-mode-hook) . (lambda ()
			     (tree-sitter-mode)
			     (tree-sitter-hl-mode))))
(use-package tree-sitter-langs
  :ensure t
  :defer t)

(use-package treesit
  :commands (treesit-install-language-grammar nf/treesit-install-all-languages)
  :init
  (setq treesit-language-source-alist
   '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
     (c . ("https://github.com/tree-sitter/tree-sitter-c"))
     (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
     (css . ("https://github.com/tree-sitter/tree-sitter-css"))
     (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
     (go . ("https://github.com/tree-sitter/tree-sitter-go"))
     (html . ("https://github.com/tree-sitter/tree-sitter-html"))
     (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
     (json . ("https://github.com/tree-sitter/tree-sitter-json"))
     (make . ("https://github.com/alemuller/tree-sitter-make"))
     (python . ("https://github.com/tree-sitter/tree-sitter-python"))
     (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
     (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
     (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
     (sql . ("https://github.com/m-novikov/tree-sitter-sql"))))
  :config
  (defun nf/treesit-install-all-languages ()
    "Install all languages specified by `treesit-language-source-alist'."
    (interactive)
    (let ((languages (mapcar 'car treesit-language-source-alist)))
      (dolist (lang languages)
	      (treesit-install-language-grammar lang)
	      (message "`%s' parser was installed." lang)
	      (sit-for 0.75)))))
;; (add-hook 'typescript-mode-hook #'(lambda () (treesit-parser-create 'typescript)))
(add-hook 'rjsx-mode-hook #'(lambda () (treesit-parser-create 'javascript)))

(require 'treesit)
;; todo , build emacs --with-tree-sitter


(defun jsx/kill-region-and-goto-start (start end)
  "Kill the region between START and END, and move the point to START."
  (message "jsx/kill-region-and-goto-start")
  (message "%d,%d" start end)
  (kill-region start end)
  (goto-char start))
;; (defun jsx/print-node-type ()
;;   "Print the type of the node at the current point and its parent nodes up to the root."
;;   (interactive)
;;   (when-let* ((node (treesit-node-at (point))))
;;     ;; Print the type of the current node
;;     (message "Current node type: %s" (treesit-node-type node))
;;     ;; Traverse up to the root and print node types
;;     (let ((parent node))
;;       (while parent
;;         (setq parent (treesit-node-parent parent))
;;         (when parent
;;           (message "Parent node type: %s" (treesit-node-type parent)))))))

(defun jsx/empty-element ()
  "Empty the content of the JSX element containing the point."
  (interactive)
  ;; (message "jsx/empty-element")
  (when-let* ((node (treesit-node-at (point)))
              (element (treesit-parent-until node (lambda (n)
                                                    (string= (treesit-node-type n) "jsx_element"))))
              (opening-node (treesit-node-child element 0))
              (closing-node (treesit-node-child element -1))
              (start (treesit-node-end opening-node))
              (end (treesit-node-start closing-node)))
    (jsx/kill-region-and-goto-start start end)))
