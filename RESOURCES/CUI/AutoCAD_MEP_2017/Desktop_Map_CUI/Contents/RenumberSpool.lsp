;;Renumber Spool
(defun c:rs ()
  (setq KA (ssget "x"))
  
;Renumber Pipe
  (command "MASKVIEW" ka "")
  (mapfilter "#39 ! 2041")		;CID not 2041(straits)
  (command "hideselected" "renumber" "a" "all" "" "" "showall")
  
;Renumber Fittings
  (command "MASKVIEW" ka "")
  (mapfilter
    "#39 = 2041 | #5025 = #53 | #5025 = #57 | #5025 = #58 | #5025 = #62 | #5025 = #63"
  )
  (command "hideselected" "renumber" "a" "all" "" "" "showall")
  
;Renumber Valves
  (command "MASKVIEW" ka "")
  (mapfilter
    "#39 = 2041 | #5025 = #4 | #5025 = #57 | #5025 = #58 | #5025 = #62 | #5025 = #63"
  )
  (command "hideselected" "renumber" "a" "all" "" "" "showall")
  
;Update BOM
  (Command "UPDATEALLMAPTABLES")
  (vl-cmdf "._-layer" "Freeze" "*insl" "")
)
