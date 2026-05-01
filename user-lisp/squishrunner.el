;;; squishrunner.el --- Run squishrunner             -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Darlan Cavalcante Moreira

;; Author: Darlan Cavalcante Moreira darcamo@gmail.com
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

;; Provide functions to easily run squishrunner for a given test
;; suite, or test case.

;;; Code:
(require 'project)


(defgroup squish nil
  "Easily call squishrunner to run a tesst suite or test case."
  :group 'tools
  :prefix "squish-")


(defcustom squish-suites-folder ""
  "The folder where test suites are, relative to the project folder."
  :type '(string)
  :safe #'stringp
  :group 'squish)


(defcustom squish-installation-directory
  (expand-file-name "~/squish-for-qt-7.1.0")
  "The folder where squish is installed.

The squishserver and squishrunner binaries should be in a `bin' folder
inside it."
  :type '(string)
  :safe #'stringp
  :group 'squish)


;; Store the last test suite that was run
(defvar squish--last-test-suite nil)


;; Store the last test case that was run
(defvar squish--last-test-case nil)


(defun squish--get-project-root-folder ()
  "Get the current project root using Emacs built-in project."
  (project-root (project-current)))


(defun squish--get-suite-folder ()
  "Get the test suite folder."
  (let ((project-root-folder (squish--get-project-root-folder)))
    (when project-root-folder
      (file-name-concat project-root-folder squish-suites-folder))))


(defun squish--get-test-suite-names ()
  "Get all test suites names in the project."
  (directory-files (squish--get-suite-folder) nil "suite_"))


(defun squish--get-squishserver-path ()
  "Get the path of the squishserver executable."
  (file-name-concat squish-installation-directory
                    "bin"
                    "squishserver"))


(defun squish--get-squishrunner-path ()
  "Get the path of the squishrunner executable."
  (file-name-concat squish-installation-directory
                    "bin"
                    "squishrunner"))


(defun squish-start-server ()
  "Run squishserver in a process."
  (interactive)
  (start-process
   "squishserver" "*Squish Server*" (squish--get-squishserver-path)
   "--verbose"))


(defun squish-stop-server ()
  "Stop the running squish server process."
  (interactive)
  (start-process
   "stopsquishserver" nil (squish--get-squishserver-path)
   "--stop"))


(defun squish--is-file (path)
  "Check that PATH is a file (and not a directory)."
  (not (string-equal "" (file-name-nondirectory path))))


(defun squish-setup-AUT ()
  "Query for the AUT location and set it up in squishserver."
  (interactive)
  (let ((aut-path
         (expand-file-name
          (read-file-name "Select AUT executable: "))))

    (unless (squish--is-file aut-path)
      (error "Choosen AUT is not a file"))

    (let ((aut-folder (file-name-directory aut-path))
          (aut-executable (file-name-nondirectory aut-path)))
      (start-process
       "setupsquishserveraut" nil (squish--get-squishserver-path)
       "--config" "addAUT" aut-executable aut-folder))))


(defun squish-run-last-test-suite ()
  "Run the last test suite, whish is stored in `squish--last-test-suite'."
  (interactive)
  (unless squish--last-test-suite
    (error "Please call `squish-ask-and-run-test-suite' first"))

  (compile
   (format "cd %s && %s --testsuite %s"
           (squish--get-suite-folder)
           (squish--get-squishrunner-path)
           squish--last-test-suite)))


(defun squish-ask-and-run-test-suite ()
  "Ask for a suite name (with completions) and run it."
  (interactive)
  (setq squish--last-test-suite
        (completing-read "Test suite" (squish--get-test-suite-names)))
  (squish-run-last-test-suite))


(defun squish--get-test-case-names (testsuite)
  "Get all test case names in TESTSUITE."
  (let ((suitefolder (file-name-concat (squish--get-suite-folder) testsuite)))
    (mapcar #'(lambda (testcase) (file-name-concat testsuite testcase)) (directory-files suitefolder nil "tst_"))))


(defun squish--get-test-case-names-in-all-suites ()
  "Get all test case names in all test suites."
  (mapcan 'squish--get-test-case-names
          (squish--get-test-suite-names)))


(defun squish-run-last-test-case ()
  "Run the last test suite, whish is stored in `squish--last-test-case'."
  (interactive)
  (unless squish--last-test-case
    (error "Please call `squish-ask-and-run-test-case' first"))

  (let ((testsuitename (file-name-directory squish--last-test-case))
        (testcasename (file-name-nondirectory squish--last-test-case)))
    (compile
     (format "cd %s && %s --testsuite %s --testcase %s"
             (squish--get-suite-folder)
             (squish--get-squishrunner-path)
             testsuitename
             testcasename))))


(defun squish-ask-and-run-test-case ()
  "Ask for a test case name (with completions) and run it."
  (interactive)
  (setq squish--last-test-case
        (completing-read "Test case" (squish--get-test-case-names-in-all-suites)))
  (squish-run-last-test-case))


;; xxxxxxxxxx Minor mode for setting keybindings xxxxxxxxxxxxxxxxxxxxx
(defvar squishrunner-mode-map (make-keymap) "A keymap for squishrunner minor mode.")

(define-minor-mode squishrunner-mode "A minor mode whose only use is having a dedicated keymap." :lighter Squish :keymap squishrunner-mode-map)
;; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

(provide 'squishrunner)
;;; squishrunner.el ends here
