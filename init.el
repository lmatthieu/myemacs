(require 'cl)
(require 'package)

;;; Dependencies & packages
(add-to-list 'load-path "~/.emacs.d/lib")
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; required because of a package.el bug
(setq url-http-attempt-keepalives nil)

(defvar my-packages '(paredit  evil auto-complete smart-tab fill-column-indicator
		      zenburn-theme))

(defun my-packages-installed-p ()
  (loop for p in my-packages
        when (not (package-installed-p p))
        do (return nil)
        finally (return t)))

(defun install-my-packages ()
  (unless (my-packages-installed-p)
    (package-refresh-contents)
    ;; install the missing packages
    (dolist (p my-packages)
      (unless (package-installed-p p)
        (package-install p)))))

(install-my-packages)

;; Evil mode
(require 'paredit)
(require 'evil)

(defun evil-passthrough (&optional arg)
  "Execute the next command in Emacs state."
  (interactive "p")
  (cond
   (arg
    (add-hook 'post-command-hook 'evil-passthrough nil t)
    (evil-emacs-state))
   ((not (eq this-command #'evil-passthrough))
    (remove-hook 'post-command-hook 'evil-passthrough t)
    (evil-exit-emacs-state))))

(global-set-key (kbd "M-p") 'evil-passthrough)

(evil-define-command evil-switch-header ()
  "Switch between header and impl"
  :repeat nil
  (interactive)
  (ff-find-related-file nil t))

(defun evil-kill-line (&optional arg)
  (interactive "p")
    (paredit-kill arg))

(evil-ex-define-cmd "A" 'evil-switch-header)

(evil-mode 1)

(mapcar #'(lambda (map)
            (define-key map (kbd "C-h") 'comment-or-uncomment-region-or-line)
            (define-key map (kbd "C-k") 'paredit-kill)
            (define-key map (kbd "C-y") 'yank))
        (list evil-insert-state-map evil-normal-state-map))

(evil-set-cursor-color "magenta")

(define-key paredit-mode-map (read-kbd-macro "C-<right>") 'paredit-forward)
(define-key paredit-mode-map (read-kbd-macro "C-<left>") 'paredit-backward)
(define-key paredit-mode-map (read-kbd-macro "M-<right>") 'paredit-forward-slurp-sexp)
(define-key paredit-mode-map (read-kbd-macro "M-<left>") 'paredit-backward-slurp-sexp)
(define-key paredit-mode-map (read-kbd-macro "M-<up>") 'paredit-backward-barf-sexp)
(define-key paredit-mode-map (read-kbd-macro "M-<down>") 'paredit-forward-barf-sexp)

;; pyhy-mode
(require 'two-mode-mode)
(require 'hy-mode)

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'hy-mode-hook             #'enable-paredit-mode)

(defun pyhy-mode ()
  "Treat the current buffer as a literate Emacs Lisp program."
  (interactive)
  (setq default-mode    '(python-mode "Python")
        second-modes     '(hy-mode ("Hy"
                            ;; We break up the values so as to not have strange
                            ;; behavior when editing this function.
                            "@(" ; }
                            ")@"  ; }
                            )))
  (two-mode-mode))

(add-to-list 'auto-mode-alist '("\\.py\\'" . pyhy-mode))

(load-theme 'zenburn t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
