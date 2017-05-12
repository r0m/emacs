;;;;;;;;;
;; GUI ;;
;;;;;;;;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
;; active multiple-car edit if package exist
(require 'multiple-cursors)
(global-set-key (kbd "C-M-<mouse-1>") 'mc/add-cursor-on-click)
;; search all ocurs
(global-set-key (kbd "C-c o") 'occur)
;; goto line
(global-set-key (kbd "<f4>") 'goto-line)
;; Comment/Uncomment region
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)
;; reload buffer from file
(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)
;; unsplit window and kill buffer
(global-set-key (kbd "C-x C-k") 'close-and-kill-this-pane)

;;;;;;;;;
;; Org ;;
;;;;;;;;;
;; set default directory and file for org mode
(setq org-directory "~/.emacs.d/org")
(setq org-agenda-files '("~/.emacs.d/org/todo.org"))
(setq org-default-notes-file "~/.emacs.d/org/notes/default.org")

;; create shortcut to display directly week agenda with todo list
(global-set-key (kbd "C-c a") 'org-agenda-show-agenda-and-todo)

;; create shortcut to change task status
(global-set-key (kbd "C-c t") 'org-todo)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "WIP(w)" "PENDING(p)" "|" "DONE(d)")
	      (sequence "|" "CANCELLED(c@/!)"))))

(setq org-todo-keyword-faces
       '(("TODO" . (:foreground "red" :weight bold))
	 ("WIP" . (:foreground "blue" :weight bold))
	 ("PENDING" . (:foreground "orange" :weight bold))
	 ("CANCELLED" . (:foreground "purple" :weight bold))
	 ("DONE" . (:foreground "#228b22" :weight bold))))

;;set priority range from A to C with default A
(setq org-highest-priority ?A)
(setq org-lowest-priority ?C)
(setq org-default-priority ?A)

;;set colours for priorities
(setq org-priority-faces '((?A . (:foreground "#F0DFAF" :weight bold))
                           (?B . (:foreground "LightSteelBlue"))
                           (?C . (:foreground "OliveDrab"))))

;; add time for done task
(setq org-log-done 'time)

;; Enable display of the time grid so we can see the marker for the current time
(setq org-agenda-time-grid (quote ((daily today remove-match)
                                   #("----------------" 0 16 (org-heading t))
                                   (0900 1000 1100 1200 1300 1400 1500 1600 1700 1800))))

;; Display tags farther right
(setq org-agenda-tags-column -102)

;; Include agenda archive files when searching for things
(setq org-agenda-text-search-extra-files (quote (agenda-archives)))

;;;;;;;;;;
;; Misc ;;
;;;;;;;;;;
;; Stop emacs daemon and client
(global-set-key (kbd "C-x c") 'kill-emacs)
;; disable backup file
(setq backup-inhibited t)
(setq auto-save-default nil)
;; disable new line at the end of file
(setq next-line-add-newlines nil)
(setq require-final-newline nil)
(setq mode-require-final-newline nil)
;; overwrite selected text
(delete-selection-mode t)
;; disable cua-keys (cut/copy/paste)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-enable-cua-keys nil)
 '(package-selected-packages
   (quote
    (org solarized-theme minimap pkg-info multiple-cursors lua-mode let-alist highlight-indentation dash))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;;;;;;;;;;;;;;
;; Functions ;;
;;;;;;;;;;;;;;;
(defun reload () (interactive)
       "Reload .emacs"
       (if (file-exists-p "~/.emacs")
	   (load-file "~/.emacs")))

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

;; http://pragmaticemacs.com/emacs/a-shortcut-to-my-favourite-org-mode-agenda-view/
(defun org-agenda-show-agenda-and-todo (&optional arg)
  (interactive "P")
  (org-agenda arg "n"))

