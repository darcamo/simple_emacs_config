
;; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;; Taken from https://raw.githubusercontent.com/snackon/Witchmacs/master/init.el
;; Make emacs startup faster by reducing garbage collection during startup

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(defun startup/reset-gc ()
  (setq gc-cons-threshold 800000
    gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)
;;

;; Initialize melpa repo
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Add the gnu-devel repository -> some packages are not available in
;; regular melpa, but might be available in gnu-devel.
(add-to-list 'package-archives
             '("gnu-devel" . "https://elpa.gnu.org/devel/") :append)
;; We want the priority of gnu-devel to be below the other
;; repositories, such that it is only used for packages that are not
;; available elsewhere
(setq package-archive-priorities '(("melpa" . 50)
                                   ("gnu" . 40)
                                   ("nongnu" . 50)
                                   ("gnu-devel" . 10)
                                   ))
(package-initialize)

;; Initialize use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Load config.org for init.el configuration
(org-babel-load-file (expand-file-name (concat user-emacs-directory "config.org")))
