
;; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;; Write customizations to a separate file instead of the init file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;; Taken from https://raw.githubusercontent.com/snackon/Witchmacs/master/init.el
;; Make emacs startup faster by reducing garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum ;;402653184
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


;; xxxxxxxxxx Bootstrap straight.el xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

(straight-use-package 'use-package)
(straight-use-package 'org)


;; Initialize melpa repo
;; (require 'package)
(setq package-enable-at-startup nil)
;; (add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/"))

;; ;; Add the gnu-devel repository -> some packages are not available in
;; ;; regular melpa, but might be available in gnu-devel.
;; (add-to-list 'package-archives
;;              '("gnu-devel" . "https://elpa.gnu.org/devel/") :append)
;; ;; We want the priority of gnu-devel to be below the other
;; ;; repositories, such that it is only used for packages that are not
;; ;; available elsewhere
;; (setq package-archive-priorities '(("melpa" . 50)
;;                                    ("gnu" . 40)
;;                                    ("nongnu" . 50)
;;                                    ("gnu-devel" . 10)
;;                                    ))
;; (package-initialize)

;; ;; Initialize use-package
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))


;; Any local package is put in the "local" folder in my emacs-directory
(add-to-list 'load-path (file-name-concat user-emacs-directory "local"))


;; Load config.org for init.el configuration
(org-babel-load-file (expand-file-name (concat user-emacs-directory "config.org")))
(put 'narrow-to-region 'disabled nil)
