;;; go_integration.el --- Easily build/run go code   -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Darlan Cavalcante Moreira

;; Author: Darlan Cavalcante Moreira <darlan@darlan-desktop>
;; Keywords: 

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
(defvar gi--main-file nil "Current main Go file to run.")


(defun gi-is-go-project-p ()
  "Check if the current project is a CMake project."
  (interactive)
  (if-let* ((project (project-current))
            (project-root (project-root project))
            (cmakelist-path (expand-file-name "go.mod" project-root)))
    (file-exists-p cmakelist-path)))


(defun gi-get-go-files ()
  "Get a list with all GO files in the project."
  (directory-files-recursively (project-root (project-current)) "\\.go$"))


(defun gi-choose-go-file ()
  "Choose a go file to run."
  (interactive)
  (setq gi--main-file
        (completing-read "Choose go file: " (gi-get-go-files))))
    
    
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
      (compile "go test ./..."))
  )

(provide 'go_integration)
;;; go_integration.el ends here


;; Local Variables:
;; read-symbol-shorthands: (("gi-" . "go-integration-"))
;; End:
