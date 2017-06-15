
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

;;Rebuild All
(defun c:rb ()
(command "rebuildall")
(princ)
)

;;Remove Hatch
(defun c:hatchBgone () 
	(command "erase" (ssget "x" '((0 . "HATCH"))) "") 
(princ) )

;;Remove All Text
(defun c:textBgone () 
	(command "erase" (ssget "x" '((0 . "mtext"))) "")
	(command "erase" (ssget "x" '((0 . "text"))) "") 
(princ) )

;;Trimble Backrgound Prep
	;exploads Trimble blocks, creats 2D, erases all MAP objects
(defun c:trimprep ()
(setvar "qaflags" 1)
(setq OBJ (ssget(MapFilter "#5025 = 105 | #5025 = 106 | #5025 = 107")))
(setq ssAll (ssget "X" '((0 . "INSERT")))drwordr (getvar "draworderctl"))
(setvar "draworderctl" 0);supress warnings
(command "_explode" OBJ "")
(setvar "draworderctl" drwordr)
(setvar "qaflags" 0)
(command "create2d" "all" "")
(setq MS(ssget "_X" '((0 . "MAPS_SOLID"))))
(command "_erase" MS "")
(princ)
)

;;Renumber Spool
(defun c:rs	()
  (setq KA (ssget))
 ;Renumber Pipe
  (command "MASKVIEW" ka "")
  (mapfilter "#39 ! 2041");CID not 2041(straits)
  (command "hideselected" "renumber" "a" "all" "" "" "showall")
 ;Renumber Fittings
  (command "MASKVIEW" ka "")
  (mapfilter "#39 = 2041 | #5025 = #53 | #5025 = #57 | #5025 = #62 | #5025 = #63")
  (command "hideselected" "renumber" "a" "all" "" "" "showall")
 ;Renumber Valves
  (mapfilter "#39 = 2041 | #5025 = #4 | #5025 = #57 | #5025 = #62 | #5025 = #63")
  (command "hideselected" "renumber" "a" "all" "" "" "showall")
 ;Renumber Welds
  (command "MASKVIEW" ka "")
  (mapfilter "#5025 ! #57")
  (command "hideselected" "renumber" "a" "all" "" "" "showall")
 ;Update BOM
 (Command "UPDATEALLMAPTABLES")
) 

 ;Explodes All
(defun C:XE ( / ssAll drwordr)
  (setq ssAll (ssget "X" '((0 . "INSERT")))
	   drwordr (getvar "draworderctl")
  )
  (setvar "draworderctl" 0);supress warnings
  (sssetfirst nil ssAll) ;makes ssAll both gripped and selected. 
  (c:burst)
  (setvar "draworderctl" drwordr)
)

; ;Renumber Hangers and Sleeves
; (defun c:rhv	()
  ; (setq KA (ssget "X"))
 ; ; Renumber Hangers
  ; (command "MASKVIEW" ka "")
  ; (mapfilter "#5025 ! #56")
  ; (command "hideselected" "renumber" "a" "all" "" "" "showall")
 ; ; Renumber Sleeves
  ; (command "MASKVIEW" ka "")
  ; (mapfilter "#5025 ! #61")
  ; (command "hideselected" "renumber" "a" "all" "" "" "showall")
; )

;View Top
(defun c:VT	()
  (command "-view" "top")
(princ)
)

;View Front
(defun c:VF	()
  (command "-view" "front")
(princ)
)