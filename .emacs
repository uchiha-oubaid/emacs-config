;(package-initialize)

(setq custom-file "~/.emacs.custom.el")

(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq-default truncate-lines t)
(defvaralias 'c-basic-offset 'tab-width)
(setq-default compilation-scroll-output 1)
(add-to-list 'default-frame-alist `(font . "Iosevka-18"))
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
;(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(global-key-binding (kbd "C-c") 'kill-compilation)

(ido-mode 1)
(setq ido-enable-flex-matching t)
(ido-everywhere 1)
(setq make-backup-files nil)
(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               (display-buffer-reuse-window display-buffer-at-bottom)
               (window-height . 0.33)
               (reusable-frames . visible)))

(require 'ansi-color)

(defun my/colorize-compilation-output ()
  "Apply ANSI colors to newly added compilation output."
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region compilation-filter-start (point))))

(add-hook 'compilation-filter-hook #'my/colorize-compilation-output)

(global-set-key (kbd "M-h") 'windmove-left)
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-l") 'windmove-right)
(global-set-key (kbd "M-k") 'windmove-up)

(global-set-key (kbd "M-<right>") 'next-buffer)
(global-set-key (kbd "M-<left>") 'previous-buffer)

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Download Evil
(unless (package-installed-p 'evil)
  (package-refresh-contents)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
(setq evil-want-C-u-scroll t)
(setq evil-want-C-d-scroll t)
(setq evil-undo-system 'undo-redo)
(setq evil-want-fine-undo t)
(evil-mode 1)

(use-package evil-escape
  :ensure t
  :after evil
  :config
  (setq evil-escape-key-sequence "jj"
        evil-escape-delay 0.2)
  (evil-escape-mode 1))

(with-eval-after-load 'evil-escape
  (add-to-list 'evil-escape-excluded-states 'visual))
(with-eval-after-load 'evil-escape
  (add-to-list 'evil-escape-excluded-major-modes 'compilation-mode 'magit))
(evil-ex-define-cmd "cd" #'cd)

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))

(use-package move-text
  :ensure t)

(require 'exec-path-from-shell)
(when (memq window-system '(mac ns x pgtk))
  (exec-path-from-shell-initialize))

(defun my-move-text-down ()
  (interactive)
  (call-interactively 'move-text-down)
  (when (use-region-p)
    (indent-region (region-beginning) (region-end))))

(defun my-move-text-up ()
  (interactive)
  (call-interactively 'move-text-up)
  (when (use-region-p)
    (indent-region (region-beginning) (region-end))))

(global-set-key (kbd "C-<up>") 'my-move-text-up)
(global-set-key (kbd "C-<down>") 'my-move-text-down)

(advice-add 'move-text-up :after
			(lambda (&rest _)
			  (when (use-region-p)
				(indent-region (region-beginning) (region-end)))))

(advice-add 'move-text-down :after
            (lambda (&rest _)
              (when (use-region-p)
				(indent-region (region-beginning) (region-end)))))

;; Keep a block cursor in Normal state, but change its color
(setq evil-normal-state-cursor '(box "yellow"))
;; Optional: customize other states for contrast
(setq evil-insert-state-cursor '(box "white"))
(setq evil-visual-state-cursor '(box "green"))

;; Force C-u to scroll up (half-page) in Normal and Visual states
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-insert-state-map (kbd "C-v") 'clipboard-yank)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-x C-s") 'isearch-forward)

;;Also bind it in the motion state map (used by some special modes like Dired or Help)
(define-key evil-motion-state-map (kbd "C-u") 'evil-scroll-up)
(global-set-key (kbd "²") 'evil-normal-state)

;; Ido
(global-set-key (kbd "C-c p") 'ido-find-file)


(load-file "~/.emacs.rc/rc.el")
(rc/require-theme 'gruber-darker)
(rc/require 'magit)
;;(rc/require 'markdown-mode)


(add-to-list 'load-path "~/.emacs.local")
(require 'simpc-mode)
(require 'odin-mode)

(rc/require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (newline)
  (yank))

(global-set-key (kbd "C-,") 'rc/duplicate-line)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(load custom-file)
