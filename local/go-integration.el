;;; go-integration.el --- Easily build/run go code   -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Darlan Cavalcante Moreira

;; Author: Darlan Cavalcante Moreira <darlan@darlan-desktop>
;; Keywords: go languages tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This file provides integration for Go projects, allowing you to easily build
;; and run Go code from within Emacs. It defines a minor mode `gi-go-project-mode`
;; that can be enabled in Go projects, and provides keybindings for running the
;; current Go file.

;;; Code:
(require 'tramp)


;; TODO Allow choosing and passing "-tags some tags" to the compile command.


;; go-main-file
(defvar gi--main-file nil
  "Current main Go file to run.")
(defvar gi--package-to-test nil
  "Current package that should be debuged.")


(defun gi--get-project-root-folder ()
  "Get the current project root using Emacs built-in project."
  (when (project-current)
    (project-root (project-current))))


(defun gi--get-project-root-folder-absolute ()
  "Get the current project root as an absolute path."
  (when (project-current)
    (expand-file-name (project-root (project-current)))))


(defun gi-is-go-project-p ()
  "Check if the current project is a CMake project."
  (interactive)
  (if-let* ((project (project-current))
            (project-root (project-root project))
            (cmakelist-path (expand-file-name "go.mod" project-root)))
    (file-exists-p cmakelist-path)))


(defun gi--get-go-files ()
  "Get a list with all GO files in the project."
  (directory-files-recursively (project-root (project-current)) "\\.go$"))


(defun gi--get-go-packages-with-tests ()
  "Get a list with all Go packages in the project that have tests.

Calls the `go list -test ./...` command in the project root and returns
the output as a list of strings only including packages that have tests."
  (let* ((default-directory (project-root (project-current)))
         (output (shell-command-to-string "go list -test ./..."))
         (lines (split-string output "\n" t))
         (packages-with-tests
          (seq-filter (lambda (line) (string-suffix-p "]" line)) lines)))

    (mapcar
     ;; NOTE: This lambda is fragile and that the paths do not have spaces in
     ;; them
     (lambda (line) (car (split-string line " "))) packages-with-tests)))

;; TODO Use gi--get-go-packages-with-tests and add a function to launch dape
;; with the chosen package

(defun gi-choose-go-file ()
  "Choose a go file to run."
  (interactive)
  (setq gi--main-file (completing-read "Choose go file: " (gi--get-go-files))))


(defun gi-choose-go-package-with-tests ()
  "Choose a go package to run or test."
  (interactive)
  (let* ((packages (gi--get-go-packages-with-tests))
         (chosen-package (completing-read "Choose go package: " packages)))
    (setq gi--package-to-test chosen-package)))


(defvar gi-go-project-mode-map (make-sparse-keymap)
  "Keymap for `gi-go-project-mode'.")


(define-minor-mode gi-go-project-mode
  "A minor-mode for Go projects.

This minor-mode does not add any functionality, but it can be used to
add keybindings to compile/run Go code and also running anything in its hook."
  :keymap gi-go-project-mode-map)


(defun gi--turn-on-project-mode-func ()
  "Turn on `gi-go-project-mode' in Go projects."
  (when (gi-is-go-project-p)
    (gi-go-project-mode 1)))


(define-globalized-minor-mode global-gi-go-project-mode
  gi-go-project-mode
  gi--turn-on-project-mode-func
  :group 'go-project)


(defun gi-run-current-file ()
  "Run the current Go file.

The working directory is set to the project root."
  (interactive)
  (if-let* ((root (project-root (project-current)))
            (default-directory root)
            (compilation-always-kill t)
            (file gi--main-file))
    (compile (format "go run %s" (tramp-file-local-name file)))
    (compile (format "go run %s" root))))


(defun gi-run-all-tests ()
  "Run the command `go test ./...` in the project root."
  (interactive)
  (if-let* ((root (project-root (project-current)))
            (default-directory root)
            (compilation-always-kill t))
    (compile "go test ./...")))


(defun gi--get-module-name ()
  "Get the module name of the current project.

This looks at the \"go.mod\" file in the project root and take the
module name from there."
  (if-let* ((project (project-current))
            (project-root (project-root project))
            (go-mod-path (expand-file-name "go.mod" project-root)))
    (with-temp-buffer
      (insert-file-contents go-mod-path)
      (goto-char (point-min))
      (when (re-search-forward "^module \\([a-zA-Z0-9_./]+\\)" nil t)
        (match-string-no-properties 1)))))


(defun gi-get-package-for-current-file ()
  "Get the package of the current file.

This will concatenate the module name with the path of the current file
relative to the project root, and then remove the file name."
  (interactive)
  (if-let* ((module-name (gi--get-module-name))
            (project-root (project-root (project-current)))
            (file-path (buffer-file-name))
            (relative-path (file-relative-name file-path project-root)))
    (let* ((package-path (file-name-directory relative-path))
           (package (concat module-name "/" package-path)))
      package)))


;; TODO Add a function to run the test at point, using `go test -run TestName`.


;; Note: This function is specially useful to be passed to dape as the :program
;; argument, since it will return the main file
(defun gi-get-main-file-relative-to-project ()
  "Get the main file relative to the project root."
  (interactive)
  (if-let* ((project-root (project-root (project-current)))
            (main-file gi--main-file))
    (file-relative-name main-file project-root)))


(defun gi-setup-dape ()
  "Setup dape configurations for Go projects."
  (interactive)
  (add-to-list
   'dape-configs
   '(gi-main
     modes
     (go-mode go-ts-mode)
     command
     "dlv"
     command-args
     ("dap" "--listen" "127.0.0.1::autoport")
     command-cwd
     dape-command-cwd
     port
     :autoport
     :type "go"
     :request "launch"
     :mode "debug"
     :name "Debug Go Program"
     :cwd go-integration--get-project-root-folder-absolute
     :program go-integration-get-main-file-relative-to-project
     :args []))

  ;; Tests on storage folder
  (add-to-list
   'dape-configs
   '(gi-package-tests
     modes
     (go-mode go-ts-mode)
     command
     "dlv"
     command-args
     ("dap" "--listen" "127.0.0.1::autoport")
     command-cwd
     dape-command-cwd
     port
     :autoport
     :type "go"
     :request "launch"
     :mode "debug"
     :name "Debug tests"
     :cwd go-integration--get-project-root-folder-absolute
     :program go-integration--package-to-test
     :args [])))


;; xxxxxxxxxx START - Identify project by go.mod file xxxxxxxxxxxxxxxxxxxxxxxxxx
;; Original code from https://go.dev/gopls/editor/emacs
(defun gi--project-find-go-module (dir)
  "Find the go module root by looking for a \"go.mod\" file from DIR."
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'gi--project-find-go-module)
;; xxxxxxxxxx - END xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


(provide 'go-integration)

;;; go-integration.el ends here

;; Local Variables:
;; read-symbol-shorthands: (("gi-" . "go-integration-"))
;; End:
