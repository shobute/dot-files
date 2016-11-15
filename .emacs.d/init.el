;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(helm
    projectile
    helm-projectile
    evil
    evil-surround
    evil-exchange
    magit
    ein
    elpy
    flycheck
    monokai-theme))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; EVIL
;; --------------------------------------
(setq evil-want-C-u-scroll t)
(setq evil-want-C-w-in-emacs-state t)

(require 'evil)
(evil-mode 1)

(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'evil-exchange)
(evil-exchange-install)

;; BASIC CUSTOMIZATION
;; --------------------------------------
(server-start)

(desktop-save-mode 1)

(setq-default indent-tabs-mode nil)
(setq whitespace-style '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark newline-mark))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq vc-handled-backends (delq 'Git vc-handled-backends)) ;; Use magit instead

(require 'whitespace)

(defvar my-leader-map (make-sparse-keymap)
  "Keymap for \"leader key\" shortcuts.")
(define-key evil-normal-state-map (kbd "SPC") my-leader-map)
(define-key my-leader-map "g" 'magit-status)
(define-key my-leader-map "s" 'whitespace-mode)

;; THEME
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'monokai t) ;; load theme
(tool-bar-mode -1)

(add-to-list 'default-frame-alist
             '(font . "Consolas-10"))

;; HELM CONFIGURATION
;; --------------------------------------
(require 'helm)
(require 'helm-config)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(helm-mode 1)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(setq projectile-indexing-method 'alien)

;; PYTHON CONFIGURATION
;; --------------------------------------

(elpy-enable)
(elpy-use-ipython)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; WINDOWS SPECIFIC SETTINGS
;; --------------------------------------
(when (eq system-type 'windows-nt)
  (setq exec-path (add-to-list 'exec-path "C:/Program Files (x86)/Gow/bin"))
  (setenv "PATH" (concat "C:\\Program Files (x86)\\Gow\\bin;" (getenv "PATH")))  
  (setq make-backup-files nil)
  (setq create-lockfiles nil)
  (tooltip-mode nil))
