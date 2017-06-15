					;Lisp Routine for ALL users of CADmep

(defun c:rr ()
  (setvar "osmode" os)
  (princ)
)

(defun c:ww ()
  (setq KA (ssget "x"))

					;Renumber Welds
  (command "MASKVIEW" ka "")
  (mapfilter "#5025 ! #57")
  (command "hideselected" "renumber" "a" "all" "" "")
  (mapfilter "#5025 = #57")
  (CTEXT "WELDSYM")
  (mapfilter "#5025 = #57")
  (csvexport "WeldLog")
  (Command "showall")



					;Update BOM
  (Command "UPDATEALLMAPTABLES")
  (vl-cmdf "._-layer" "Freeze" "*insl" "")
)



					; Command to add CFM, Grille Type, plus add tag automatically
					; Select "like" grilles, IE same CFM, Same Type

					; Labels Grille Tags in Model Space with prompt for Type and CFM thru script
(defun c:gtms (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025=#34" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (if ss
    (settext ss 1 "off")
  )
  (Executescript "zLisp-grd.cod" ss)
  (CTEXT "MS_GRD-TAG" ss)
  (sssetfirst nil)
  (princ)
)

					; Labels Grille Tags in Paper Space with prompt for Type and CFM thru script
(defun c:gtps (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025=#34" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (if ss
    (settext ss 1 "off")
  )
  (Executescript "zLisp-grd.cod" ss)
  (CTEXT "PS_GRD-TAG" ss)
  (sssetfirst nil)
  (princ)
)

					; Run once spool is created.  In viewport

(defun c:qw ()
  (setq ss (ssget "x"))
  (vl-cmdf "._-layer" "Freeze" "*insl" "") ; freezes all insulation
  (if ss
    (settext ss 110 "off" 1)
  )					; turns off all text except numbers and sets
)

					; Turn on Elevation and Size on Selection Set

(defun c:se ()
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (settext ss 6 "on")
  (sssetfirst nil)
)

					; Turn off CTEXT when on Spools
(defun c:ct ()
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (settext ss 64 "off")
  (sssetfirst nil)
)

					; Add Notes Field
(defun c:addnf (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "C:/Autodesk Fabrication/ENGworks V5.1/SCRIPTS/zLisp-Write Notes Field.cod" ss)
  (sssetfirst nil)
  (princ)
)

					; Model Space placement of Valve Tag Block on all Valves
(defun c:vtms (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025 = #53" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (CTEXT "MS_Valve-Tag" ss)
  (sssetfirst nil)
  (princ)
)

					; Model Space placement of Valve Tag Block on all Valves
(defun c:vtps (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025 = #53" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (CTEXT "PS_Valve-Tag" ss)
  (sssetfirst nil)
  (princ)
)

					; Place EQ tag on Equipment in Model Space. ; Only works if EQ-Tag filled out on equipment
(defun c:equipms (/ ss)
  (ctext "MS_EQ-TAG" ss)
  (sssetfirst nil)
  (princ)
)

					; Place EQ tag on Equipment in Paper Space. ; Only works if EQ-Tag filled out on equipment
(defun c:equipps (/ ss)
  (ctext "PS_EQ-TAG" ss)
  (sssetfirst nil)
  (princ)
)

					; Place VAV tag on VAV boxes in Model Space. ; Only works if VAV field is filled out on VAV boxes.
(defun c:vavms (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025 = #38" 0 1 0 ss)	; filters Service Type for index 38(VAV Box)
  (setq ss (ssget "_I"))
  (CTEXT "MS_VAV-TAG" ss)
  (sssetfirst nil)
  (princ)
)

					; Place VAV tag on VAV boxes in Paper Space. ; Only works if VAV field is filled out on VAV boxes.
(defun c:vavps (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025 = #38" 0 1 0 ss)	; filters Service Type for index 38(VAV Box)
  (setq ss (ssget "_I"))
  (CTEXT "PS_VAV-TAG" ss)
  (sssetfirst nil)
  (princ)
)

					; Model Space Ctext for Elbow throats, Rect and Round
(defun c:ttms (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#39 = 20 | #39 = 17" 0 1 0 ss)
					; filters CID(39) for 20(rect) and radius(17)
  (setq ss (ssget "_I"))
  (CTEXT "MS_Throat-1" ss)
  (setq ss (ssget "_I"))
  (ADDCTEXT "MS_Throat-2" ss)
  (sssetfirst nil)
  (princ)
)

					; Paper Space Ctext for Elbow throats, Rect and Round
(defun c:ttps (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#39 = 20 | #39 = 17" 0 1 0 ss)
					; filters CID(39) for 20(rect) and radius(17)
  (setq ss (ssget "_I"))
  (CTEXT "PS_Throat-1" ss)
  (setq ss (ssget "_I"))
  (ADDCTEXT "PS_Throat-2" ss)
  (sssetfirst nil)
  (princ)
)

					; Hanger Report Process
(defun c:Hh (/)
  (command "executeprocess" "reports-hangers")
)

					; Model Space Fire Damper Tags
(defun c:fdams (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025 = #36" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (CTEXT "MS_FD-TAG" ss)
  (sssetfirst nil)
  (princ)
)

					; Paper Space Fire Damper Tags
(defun c:fdaps (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025 = #36" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (CTEXT "PS_FD-TAG" ss)
  (sssetfirst nil)
  (princ)
)

					; Model Space Rectangular Access Door Tags
(defun c:radams	(/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#39 = #504 & #5025 = #37" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (CTEXT "MS_ADrect-Tag" ss)
  (sssetfirst nil)
  (princ)
)

					; Paper Space Rectangular Access Door Tags
(defun c:radaps	(/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#39 = #504 & #5025 = #37" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (CTEXT "PS_ADrect-Tag" ss)
  (sssetfirst nil)
  (princ)
)

					; Duct Accessory Annotation Model Space, filters for Duct Accessory, Control Damper and Access Door
(defun c:daams (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025 = #37 | #5025 = #33 | #5025 = #35"
	     0				1
	     0				ss
	    )
  (setq ss (ssget "_I"))
  (settext ss 8 "on")
  (sssetfirst nil)
  (princ)
)

					; Duct Accessory Annotation Paper Space, filters for Duct Accessory, Control Damper and Access Door
(defun c:daaps (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5025 = #37 | #5025 = #33 | #5025 = #35"
	     0				1
	     0				ss
	    )
  (setq ss (ssget "_I"))
  (settext ss 8 "on")
  (sssetfirst nil)
  (princ)
)

					; Print Preview with Execute script for Area/Level
(defun c:ppal (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-area level.cod" ss)
  (command "ppreview" ss "")
  (sssetfirst nil)
  (princ)
)

					; Point Load with Addservicetypeblock
(defun c:hpl (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Hanger Point Load Service.cod" ss)
  (command "addservicetypeblock" ss "")
  (sssetfirst nil)
  (princ)
)

					; NC Reports
(defun c:ppnc (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-area level.cod" ss)
  (command "executeprocess" "Z-ReportsNC" ss "")
  (sssetfirst nil)
  (princ)
)

					; Hanger Reports
(defun c:pphgr (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-area level.cod" ss)
  (command "executeprocess" "Z-ReportsHanger" ss "")
  (sssetfirst nil)
  (princ)
)

                                        ; Set Pipe Termination Height
(defun c:SPTH (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "C:/Autodesk Fabrication/ENGworks V5.1/SCRIPTS/zLisp-Set Pipe Termination Height.cod" ss)
  (sssetfirst nil)
  (princ)
)

					; Adjust Hanger Width 
(defun c:HASW (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "C:/Autodesk Fabrication/ENGworks V5.1/SCRIPTS/zLisp-Hanger Change C-C Rod.cod" ss)
  (sssetfirst nil)
  (princ)
)

					; Adjust Hanger Rod Height 
(defun c:Strh (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "C:/Autodesk Fabrication/ENGworks V5.1/SCRIPTS/zLisp-Set Rod Height.cod" ss)
  (sssetfirst nil)
  (princ)
)
					; Round Hanger rod Height to 1/2"
(defun c:rrnh (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "C:/Autodesk Fabrication/ENGworks V5.1/SCRIPTS/zLisp-Hanger Rod Rounding to Half Inch.cod" ss)
  (sssetfirst nil)
  (princ)
)

					; Adjust hanger for Insulation
(defun c:AHFI (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "C:/Autodesk Fabrication/ENGworks V5.1/SCRIPTS/zLisp-Hanger For Insulation Adjust.cod" ss)
  (sssetfirst nil)
  (princ)
)
					; Set Hanger Rod Height to Soffit
(defun c:SHRSE (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "C:/Autodesk Fabrication/ENGworks V5.1/SCRIPTS/zLisp-Set Hanger Rods to Section Elevation.cod" ss)
  (sssetfirst nil)
  (princ)
)
					; Write Custom Data Fields
(defun c:wcd (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "ZLisp-Write Custom Data.cod" ss)
  (sssetfirst nil)
  (princ)
)

					; Set Sleeve Stop Depth
(defun c:sssd (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Sleeve Stop Depth.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:srh (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Rod Height.cod" ss)
  (sssetfirst nil)
  (princ)
)



					; Linear Nest Reports 
(defun c:lnr (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5113 > 0" 0 1 0 ss)
  (command "executeprocess" "zLisp-Linear Nest" ss "")
  (sssetfirst nil)
  (princ)
)

					; Reset Spool Color and Remove Spool Names 
(defun c:rsc (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (command "resetspoolcol" ss "")
  (executescript "zLisp-Remove Spool Names.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun C:MisElev (/ PickPoint ZCoord TextStr)
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

					; Turns off Item Tags in Model Space, temporary solution when spooling turns them on
(defun c:itago ()
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (mapfilter "#5113 > 0 & #5019 = #4" 0 1 0 ss)
  (setq ss (ssget "_I"))
  (settext ss 1 "0ff")
  (sssetfirst nil)
)

(defun c:hlp (/)
 (startapp "explorer" "http://help.autodesk.com/view/FABRICATION/2016/ENU/")
(princ)
)

(defun c:Ym (/ ss)
  (setq ss (ssget))
  (command "._move" ss "" pause ".xz" "@" pause)
  (princ)
)

(defun c:Xm (/ ss)
  (setq ss (ssget))
  (command "._move" ss "" pause ".yz" "@" pause)
  (princ)
)

(defun c:Zm (/ ss)
  (setq ss (ssget))
  (command "._move" ss "" pause ".xy" "@" pause)
  (princ)
)

(defun c:elevmove (/ v ss i dLoad)
  (setq mapelevmoveFile "C:/Autodesk Fabrication/ENGworks V5.0/SCRIPTS/mapelevmove.lsp")
  REM
  (setq aaa (strcat (getvar "Logfilepath") "mapelevmove.lsp"))

  (executescript "elevmove.cod")
  (wait 50)
  (setq
    sLoad (load mapelevmoveFile "failed")
    i	  1
  )
  (if (= sLoad "failed")
    (alert (strcat "Failed to load '" mapelevmoveFile "'."))
  )
  (princ)
)

(defun wait (d)
  (setq
    iStart (atoi (substr (rtos (getvar "cdate") 2 8) 12))
    iNow   (atoi (substr (rtos (getvar "cdate") 2 8) 12))
  )
  (while (> d (- iNow iStart))
					;(princ (- iNow iStart))
					;(terpri)
    (setq iNow (atoi (substr (rtos (getvar "cdate") 2 8) 12)))
)


(defun c:ptr ()
  (command "ucs" "v" "")
  (command "positioner")
  (command "ucs" "")
  (princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;
;;;		Section for changing connectors
;;;
;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:cgb (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors GRVxBE.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:cgm (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors GRVxMPT.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:cbm (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors BExMPT.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:cmg (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors MPTxGRV.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:cbg (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors BExGRV.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:cmb (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors MPTxBE.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:cgg (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors GRVxGRV.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:cbb (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors BExBE.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:cmm (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors MPTxMPT.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:h2s (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Set Connectors Tyler Hub To Spigot.cod" ss)
  (sssetfirst nil)
  (princ)
)

(defun c:chsd (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Change_Sleeve_Size.cod" ss)
  (sssetfirst nil)
  (princ)
)


(defun c:chsl (/ ss)
  (setq ss (ssget '((0 . "MAPS_SOLID"))))
  (executescript "zLisp-Change_Sleeve_Length.cod" ss)
  (sssetfirst nil)
  (princ)
)

(princ "CADmep Main.lsp loaded.")

