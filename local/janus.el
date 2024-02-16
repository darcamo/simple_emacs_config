(defconst my/janus-colors '(("white" "#ffffff")
                            ("black" "#000000")
                            ("transparent" "#00000000")
                            ("pacificBlueB25" "#ECF5F6")
                            ("pacificBlueB300" "#4CCCD7")
                            ("pacificBlueB600" "#00B7C8")
                            ("pacificBlueB700" "#03929D")
                            ("pacificBlueB800" "#057E85")
                            ("pacificBlueB900" "#075B5C")
                            ("astronauteBlueB100" "#B3D7F0")
                            ("grayG5" "#F9F9F9")
                            ("grayG10" "#F4F4F4")
                            ("grayG20" "#E0E0E0")
                            ("grayG30" "#C6C6C6")
                            ("grayG40" "#A8A8A8")
                            ("grayG50" "#8D8D8D")
                            ("grayG60" "#6F6F6F")
                            ("grayG70" "#525252")
                            ("grayG80" "#393939")
                            ("grayG90" "#262626")
                            ("grayG100" "#161616")
                            ("criticalR25" "#FDF3F2")
                            ("criticalR600" "#F43B17")
                            ("criticalR700" "#D82B0D")
                            ("criticalR800" "#D82B0D")
                            ("criticalR900" "#BF1A02")
                            ("warningY25" "#FEF9F0")
                            ("warningY900" "#DC5A25")
                            ("successG25" "#F2FAF6")
                            ("successG600" "#169F67")
                            ("successG900" "#065C39")
                            ("informationalIB25" "#EBF3FA")
                            ("informationalIB700" "#106EEA")
                            ("informationalIB800" "#185CD7")
                            ("informationalIB900" "#1E3BB8")
                            ("switchChecked" "#4BBA86")
                            ("switchCheckedBorder" "#17a81a")
                            ("switchUnCheckedBorder" "#cccccc")
                            ("switchUpUnCheckedBorder" "#21be2b")
                            ("almostWhite" "#999999"))
  "Colors defined in the Palette for Janus."
  )

;; Each element in the list has 3 elements, the completion, the
;; annotation, and the string that will be inserted
(defconst my/janus-colors--completion  (mapcar (lambda (arg)
                                                 (let* (
                                                        (colorName (car arg))
                                                        (colorCode (upcase (car (cdr arg))))
                                                        (fullColorName (concat "Palette." colorName))
                                                        )
                                                   `(,(format "%s (%s)" colorName colorCode) ,fullColorName ,colorCode)
                                                   )) my/janus-colors))

(defun my/choose-qml-janus-color--annotation-function (s)
  "Annotate the cadidate S."
  (let ((item (assoc s minibuffer-completion-table)))
    (when item ;; item will be one of the elements in my/janus-colors
      (let* ((annotation-column 40)
             (num-spaces (max 1 (- annotation-column (length s)))))
        (concat (make-string num-spaces 32) (marginalia-annotate-color (third item)))
        ))))


(defun my/choose-qml-janus-color ()
  "Choose a color using completions from `my/janus-colors'.
If no match found, then whatever was typed will be returned
inside quotes."
  (interactive)
  (let* ((all-completions my/janus-colors--completion)
         (choice (let ((completion-extra-properties '(:annotation-function my/choose-qml-janus-color--annotation-function)))
                   (completing-read "Prompt: " all-completions))))
    (let ((item (assoc choice all-completions)))
      (if item
          (nth 1 item)
        (format "\"%s\"" choice)))))


(defun my/insert-qml-janus-color ()
  "Select a color using `my/choose-qml-janus-color' and insert it in the buffer."
  (interactive)
  (insert (my/choose-qml-janus-color))
  )
