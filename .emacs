;;;;;;;;;
;; GUI ;;
;;;;;;;;;
;; maximized emacs on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; disabled menu bar
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;; Disabled tool bar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; disabled scroll bar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; Inhibit startup screen
(setq inhibit-startup-screen t)


;; Display line number, only in graphic mode and for specific buffer
;; Inspired from https://www.emacswiki.org/emacs/linum-off.el
(add-hook 'after-change-major-mode-hook
	  '(lambda ()
	     (linum-mode (if (or (not (display-graphic-p))
				 (minibufferp)
				 (string-match "*" (buffer-name))
				 (> (buffer-size) 3000000) ;; disable linum on buffer greater than 3MB, otherwise it's unbearably slow
				 ) 0 1))))

;; Display column number
(setq column-number-mode t)
;; Highlighted current line
(global-hl-line-mode 1)
;; Auto Highlight parenthesis
(show-paren-mode 1)
;; Date and time in status bar
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)
;; Disable menu-buffer popup
(global-unset-key (kbd "C-<mouse-1>"))
;; Change "yes or no" by "y or no"
(fset 'yes-or-no-p 'y-or-n-p)
;; Disable tooltip-mode
(tooltip-mode t)
;; Don't show help function
(setq show-help-function nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Network and packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; set repository to downloads package
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("marmalade" . "https://marmalade-repo.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
;; ssh connection
(require 'tramp)
(setq tramp-default-method "ssh")


;;;;;;;;;;;;;
;; Editing ;;
;;;;;;;;;;;;;
;; Set major mode to text mode by default
(setq default-major-mode 'text-mode)
;; active cua-mode by default
(cua-mode t)
;; active multiple-car edit
(add-to-list 'load-path "~/.emacs.d/elpa/multiple-cursors")
(require 'multiple-cursors)
(global-set-key (kbd "C-M-<mouse-1>") 'mc/add-cursor-on-click)
;; search all ocurs
(global-set-key (kbd "C-c o") 'occur)
;; goto line
(global-set-key (kbd "<f4>") 'goto-line)
;; select all
(global-set-key (kbd "C-c C-a") 'mark-whole-buffer)
;; Comment/Uncomment region
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)
;; reload buffer from file
(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)
;; unsplit window and kill buffer
(global-set-key (kbd "C-x C-k") 'close-and-kill-this-pane)

;;;;;;;;;;;
;; Other ;;
;;;;;;;;;;;
;; Stop emacs daemon and client
(global-set-key (kbd "C-x c") 'kill-emacs)
;; disable backup file
(setq backup-inhibited t)
(setq auto-save-default nil)
;; disable new line at the end of file
(setq next-line-add-newlines nil)
(setq require-final-newline nil)
(setq mode-require-final-newline nil)
;; disable cua-keys (cut/copy/paste)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-enable-cua-keys nil)
 '(org-agenda-files (quote ("~/.org/todo.org")))
 '(package-selected-packages
   (quote
    (minimap seq pkg-info org multiple-cursors lua-mode let-alist highlight-indentation dash))))

;;;;;;;;;;;;;;;
;; Functions ;;
;;;;;;;;;;;;;;;
(defun reload () (interactive)
       "Reload .emacs"
       (if (file-exists-p "~/.emacs")
	   (load-file "~/.emacs")))
(put 'downcase-region 'disabled nil)

(defun revert-buffer-no-confirm () (interactive)
       "Revert buffer without confirmation"
       (revert-buffer :ignore-auto :noconfirm))

;; Orig. src https://www.emacswiki.org/emacs/KillingBuffers
(defun close-and-kill-this-pane ()
  "If there are multiple windows, then close this pane and kill the buffer in it also."
  (interactive)
  (kill-this-buffer)
  (if (not (one-window-p))
      (delete-window)))

