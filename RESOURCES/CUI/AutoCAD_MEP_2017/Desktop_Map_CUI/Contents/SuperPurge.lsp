; Lisp Routine to clean up drawings with extra information

(defun c:superp ()

(COMMAND "-PURGE" "R" "*" "N") ;Purge RegApps

(COMMAND "-PURGE" "E") ;Empty Text

(COMMAND "-PURGE" "Z") ;Zero Length Geometry


(COMMAND "-SCALELISTEDIT" "R" "Y" "E") ;Sets ScaleList to Acad Defaults

(princ)

)

