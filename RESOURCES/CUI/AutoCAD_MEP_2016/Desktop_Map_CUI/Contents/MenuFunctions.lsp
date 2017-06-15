;;;=== Menu Functions ===

;;Spool Tag
(defun c:Spooltag ()
  (CTEXT "spool-tag"
  )
)

;;Item Annotation
(defun c:ItemAnno ()
  (Addreport "Item Annotation"
  )
)

(defun C:RandomElevation (/ PickPoint ZCoord TextStr)
  ;; Pick the point, get its Z coordinate and make the string.
  (setvar "cmdecho" 0)
  (setq	PickPoint (getpoint "\nSpecify point: ")
	PickPoint (trans PickPoint 1 0)
	ZCoord	  (nth 2 PickPoint)
	TextStr	  (rtos ZCoord)
	TextStr	  (strcat "ELE_" TextStr)
  )
  (command "text" pause "" "" TextStr "")
  (setvar "cmdecho" 1)
)

;;Tag Duct Item
(defun c:CAD-Duct-Item ()
  (Addreport "Duct-Item"
  )
)

;;Tag Diffuser
(defun c:Anno-Diffuser ()
  (CTEXT "Anno-Diffuser"
  )
)

;;Export Trimble Background to Nomad
(defun c:trimblein ()
  (command "._layer" "_U" "*" "_T" "*" "_ON" "*" "")
  (command "._scale" "_All" "" "0,0,0" "1/12")
  (command "._saveas" "_DXF" "16" "")
  (princ)
)

;;Import Trimble Background to AutoCAD
(defun c:trimbleout ()
  (command "._layer" "_U" "*" "_T" "*" "_ON" "*" "")
  (command "._scale" "_All" "" "0,0,0" "12.0")
  (command "._saveas" "_DXF" "16" "")
  (princ)
)

;;Set Attacher
(defun c:sa ()
  (command "attacher")
  (princ)
)

;;Remove Attacher
(defun c:ra ()
  (command "attachoff")
  (princ)
)

;;nwcout
(defun c:nn ()
  (command "nwcout")
  (princ)
)

;;CADmep+ Help
(defun c:CADmephelp (/)
  (Command
    (Help
      "C:/Program Files/Autodesk/Fabrication 2015/CADmep/en-US/CADmep.chm"
    )
  )
  (princ)
)

;;Rebuild All
(defun c:rb ()
  (command "rebuildall")
  (princ)
)

;;Fill Design Line
(defun c:FD ()
  (command "FILLOBJS")
  (princ)
)

;;Strip Design Line
(defun c:SD ()
  (command "ERASE3DDITEMS")
  (princ)
)

;;Copy From Base Point
(defun c:CPYBP ()
  (command "_copybase" "0,0,0")
  
)

;;Paste at Base Point
(defun c:bppst ()
  (command "_pasteblock" "0,0,0")
    
)
;;Copy From Base Point
(defun c:CPYypt ()
  (command "_copybase")
  
)

;;Paste at Your Base Point
(defun c:bpypst ()
  (command "_pasteblock")
    
)