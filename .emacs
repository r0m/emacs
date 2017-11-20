

;;;;;;;;;;
;; Init ;;
;;;;;;;;;;
(package-initialize)

;; add path in load-path
(add-to-list 'load-path "~/.emacs.d/lisp")

;; required package
(require 'tramp)
;; active multiple-cursors edit if package exist
(require 'multiple-cursors)

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
;; overwrite selected text
(delete-selection-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Network and packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; set repository to downloads package
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))

;; ssh connection
(setq tramp-default-method "ssh")

;;;;;;;;;;;;;
;; Editing ;;
;;;;;;;;;;;;;
;; Set major mode to text mode by default
(setq default-major-mode 'text-mode)
;; active cua-mode by default
(cua-mode t)
;; define own shortcut to add cursor on click
(global-set-key (kbd "C-M-<mouse-1>") 'mc/add-cursor-on-click)
;; search all ocurs
(global-set-key (kbd "C-c o") 'occur)
;; goto line
(global-set-key (kbd "<f4>") 'goto-line)
;; Comment/Uncomment region
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)
;; reload buffer from file
(global-set-key (kbd "<f5>") 'my-revert-buffer-no-confirm)
;; unsplit window and kill buffer
(global-set-key (kbd "C-x C-k") 'my-close-and-kill-this-pane)

;;;;;;;;;
;; org ;;
;;;;;;;;;
;; set default directory and file for org mode
(setq org-directory "~/.emacs.d/org")
(setq org-agenda-files '("~/.emacs.d/org/todo.org"))
(setq org-default-notes-file (concat org-directory "/default.org"))

;; create shortcut to display directly week agenda with todo list
(global-set-key (kbd "C-c a") 'my-org-agenda-show-agenda-and-todo)

;; create shortcut to open note or create it
(global-set-key (kbd "C-c n") 'my-org-note-file)

;; create shortcut to change task status
(global-set-key (kbd "C-c t") 'org-todo)

(setq org-capture-templates
      (quote (("h" "hd ticket" entry (file+headline "~/.emacs.d/org/todo.org" "_HD_")
	       "** %^{status} %^{priority} %^{id} %^{description}")
	      ("c" "chg ticket" entry (file+headline "~/.emacs.d/org/todo.org" "_CHGH_")
	       "** %^{status} %^{priority} %^{id} %^{description}")
	      ("o" "other" entry (file+headline "~/.emacs.d/org/todo.org" "_OTHER_")
	       "** %^{description}")
	      ("n" "note" entry (file "~/.emacs.d/org/default.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              )))
	 

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
(setq org-default-priority ?C)

;;set colours for priorities
(setq org-priority-faces '((?A . (:foreground "#F0DFAF" :weight bold))
                           (?B . (:foreground "LightSteelBlue"))
                           (?C . (:foreground "OliveDrab"))))

;; add time for done task
(setq org-log-done 'time)
(setq org-agenda-log-mode-items '(closed clock state))

;; Enable display of the time grid so we can see the marker for the current time
(setq org-agenda-time-grid (quote ((daily today remove-match)
				   (0900 1000 1100 1200 1300 1400 1500 1600 1700 1800)
				   "......"
                                   #("----------------" 0 16 (org-heading t)))))

(setq org-agenda-remove-tags t)

;; Display tags farther right
(setq org-agenda-tags-column -102)

;; Include agenda archive files when searching for things
(setq org-agenda-text-search-extra-files (quote (agenda-archives)))

;;;;;;;;;;
;; Misc ;;
;;;;;;;;;;
;; Stop emacs daemon and client
(global-set-key (kbd "C-x c") 'kill-emacs)

;; Switch between frame
(global-set-key (kbd "C-x O") 'my-switch-to-frame)

;; backup file management
(setq backup-inhibited nil)
(setq auto-save-default nil)
(setq make-backup-file-name-function 'my-backup-file-name)

;; disable new line at the end of file
(setq next-line-add-newlines nil)
(setq require-final-newline nil)
(setq mode-require-final-newline nil)

;; set-register some files
(set-register ?e (cons 'file "~/.emacs"))
(set-register ?h (cons 'file "~/.emacs.d/org/emacs.org"))

;; disable cua-keys (cut/copy/paste)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(cua-enable-cua-keys nil)
 '(custom-safe-themes
   (quote
    ("ab928e0eedcdf9323f9589b7d761c6f5c746b5621fb0224837808f18c18981e8" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" default)))
 '(fci-rule-color "#383838")
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (zerodark-theme projectile zenburn-theme org solarized-theme minimap pkg-info multiple-cursors lua-mode let-alist highlight-indentation dash)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))

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
(defun my-reload ()
  "Reload .emacs"
  (interactive)
  (if (file-exists-p "~/.emacs")
      (load-file "~/.emacs")))

(defun my-revert-buffer-no-confirm ()
  "Revert buffer without confirmation"
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))

;; Orig. src https://www.emacswiki.org/emacs/KillingBuffers
(defun my-close-and-kill-this-pane ()
  "If there are multiple windows, then close this pane and kill the buffer in it also."
  (interactive)
  (kill-this-buffer)
  (if (not (one-window-p))
      (delete-window)))

(defun my-org-agenda-show-agenda-and-todo (&optional arg)
  "Load org agenda with all todo item"
  (interactive "P")
  (org-agenda arg "n")
  (org-agenda-log-mode t))

(defun my-list-files-rm-extension (lfiles)
  "Remove extension of all files in a list"
  (let* (( list-files-no-ext '()))
    (while lfiles
      (push (file-name-sans-extension (pop lfiles)) list-files-no-ext))
    list-files-no-ext)
  )

(defun my-org-note-file (note)
  "Open note file if exist or create it"
  (interactive
   (list (completing-read "Open note: " (my-list-files-rm-extension
					 (directory-files (expand-file-name org-directory) nil "\\.org$")))))
  (find-file (concat org-directory "/" note ".org")))

;; orig src http://ergoemacs.org/emacs/emacs_set_backup_into_a_directory.html
;; make backup to a designated dir, mirroring the full path
(defun my-backup-file-name (fpath)
  "Return a new file path of a given file path. If the new path's directories does not exist, create them."
  (let* (
        (backupRootDir "/tmp/emacs.bckp/")
        (filePath (replace-regexp-in-string "^[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path, for example, “C:”
	(filePath (replace-regexp-in-string ":" "" filePath )) ; remove all occurence of ":" for tramp path
        (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") ))
        )
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))

;; orig src https://github.com/john2x/nameframe/blob/master/nameframe.el
(defun my-frame-alist ()
  "Return an alist of named frames."
  (mapcar (lambda (f) `(,(cdr (assq 'name (frame-parameters f))) . ,f)) (frame-list)))

(defun my-switch-to-frame (frame-name)
  "Interactively switch to an existing frame with name frame-name."
  (interactive
   (list (completing-read "Switch to frame: " (mapcar 'car (my-frame-alist)))))
  ;; is it possible that `my-frame-alist' would return a different value
  ;; from the previous call done in the `interactive' form above?
  (let* ((frame-alist (my-frame-alist))
         (frame (cdr (assoc frame-name frame-alist))))
    (when frame
      (message "Switched to frame %s" frame-name)
      (select-frame-set-input-focus frame))))



