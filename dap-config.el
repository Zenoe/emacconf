;;; emacconf/dap-config.el -*- lexical-binding: t; -*-

(require 'dap-node)
;; download vscode-node-debug2
;; and unzip it (need unzip)
(dap-node-setup)
(after! dap-mode
  (map! :map dap-mode-map
        :leader
        :prefix ("d" . "dap")
        ;; basics
        :desc "dap next"          "n" #'dap-next
        :desc "dap step in"       "i" #'dap-step-in
        :desc "dap step out"      "o" #'dap-step-out
        :desc "dap continue"      "c" #'dap-continue
        :desc "dap hydra"         "h" #'dap-hydra
        :desc "dap debug restart" "r" #'dap-debug-restart
        :desc "dap debug"         "s" #'dap-debug

        (:prefix-map ("d" . "Debug")
                     (
                      :desc "dap debug recent"  "r" #'dap-debug-recent
                      :desc "dap debug last"    "l" #'dap-debug-last))


        ;; eval
        (:prefix-map ("e" . "Eval")
                     (:desc "eval"                "e" #'dap-eval
                      :desc "eval region"         "r" #'dap-eval-region
                      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
                      :desc "add expression"      "a" #'dap-ui-expressions-add
                      :desc "remove expression"   "d" #'dap-ui-expressions-remove))

        ;; breakpoints
        (:prefix-map ("b" . "Breakpoint")
                     (:desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
                      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
                      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
                      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message))

        ))

(defun debug-with-dap ()
  (interactive)
  (dap-mode 1)

  ;; The modes below are optional
  (dap-ui-mode 1)
  ;; enables mouse hover support
  (dap-tooltip-mode 1)
  ;; use tooltips for mouse hover
  ;; if it is not enabled `dap-mode' will use the minibuffer.
  (tooltip-mode 1)
  ;; displays floating panel with debug buttons
  ;; requies emacs 26+
  ;; (dap-ui-controls-mode 1)
  ;;
  ;;
    (set-face-background 'dap-ui-marker-face "#D124FF") ; An orange background for the line to execute
    (set-face-attribute 'dap-ui-marker-face nil :inherit nil) ; Do not inherit other styles
    (set-face-background 'dap-ui-pending-breakpoint-face "#D33623") ; Blue background for breakpoints line
    (set-face-attribute 'dap-ui-verified-breakpoint-face nil :inherit 'dap-ui-pending-breakpoint-face)
  )
