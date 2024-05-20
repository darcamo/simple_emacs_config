;;; squish-feature.el --- Fontify squish feature files  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Darlan Cavalcante Moreira (CW)

;; Author: Darlan Cavalcante Moreira <darcamo@gmail.com>
;; Keywords: squish, python, Qt

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

;; Fontify squish feature files.

;;; Code:

(defvar squish-feature--regexp-title "^\\(Feature:\\) \\(.+$\\)")


(defvar squish-feature--regexp-scennario
  "^[[:space:]]\\{4,\\}\\(Scenario:\\)\\([[:space:]].+$\\)")


(defvar squish-feature--regexp-keywords
  "^[[:space:]]\\{4,\\}\\(Given\\|When\\|And\\|Then\\)\\([[:space:]].+$\\)")

(defvar squish-feature--regexp-inside-quotes "'.+'")


(defvar squish-feature--fontlock
  `((,squish-feature--regexp-title 1 'font-lock-type-face)
    (,squish-feature--regexp-title 2 'font-lock-variable-name-face)
    (,squish-feature--regexp-scennario 1 'font-lock-number-face)
    (,squish-feature--regexp-scennario
     2 'font-lock-variable-name-face)
    (,squish-feature--regexp-keywords 1 'font-lock-builtin-face)
    ;; (,squish-feature--regexp-keywords 2 'font-lock-string-face)
    (,squish-feature--regexp-inside-quotes
     . 'font-lock-preprocessor-face)))


(define-derived-mode squish-feature-mode fundamental-mode "Feature"
  "Major mode for editing squish feature files."
  (setq font-lock-defaults '(squish-feature--fontlock)))


(provide 'squish-feature)
;;; squish-feature.el ends here
