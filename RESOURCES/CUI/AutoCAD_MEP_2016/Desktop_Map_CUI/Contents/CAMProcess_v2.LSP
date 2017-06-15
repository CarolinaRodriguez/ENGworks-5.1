


(defun c:ccam (/ ss ss1 ss2 test ssall)

  (setvar "cmdecho" 1)
  (setq loop 1)
  (setq ss (ssadd))
  (setq oss (ssadd))
  (command "jobinfo")
  (setq ssall (ssget "_X" '((0 . "MAPS_SOLID"))))
  (executescript "Set BoughtOut-v1.cod" ssall)
  (executescript "zLisp-CAMprocess-2.cod" ssall)
  (executescript "zLisp-CAMprocess-1.cod" ssall)

  
  (while (> loop 0)
    (princ "Select System to Isolate....." )
    (command-s "sl1")
    (command "selectrun" pause)
    (setq test (ssget "_I"))

    (while (not (null test))
      (while (> (sslength test) 0)	; loop that adds additional SR items to the set, if no more items wanted, enter to move on
	(ssadd (ssname test 0) ss)
	(ssdel (ssname test 0) test)
	(sssetfirst nil ss)
      )
      (command "selectrun" pause)
      (setq test (ssget "_I"))
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (setq PacketN "CPFLxyz12")
    (setq PacketSS nil)
    (setq NewcDataList nil)
    (setq ReverseNewcDataList nil)
    (if	(setq s (ssget (mapfilter "*")))
      (repeat (setq i (sslength s))
	(setq e (ssname s (setq i (1- i))))
	(DumpList e)
	(setq PacketO (car (assoc PacketN ReverseNewcDataList)))
					;(if (wcmatch PacketO PacketN) ; THERE HAS TO BE A WAY TO USE WCMATCH FOR THIS. 
	(if (= PacketO PacketN)
	  (progn
	    (if	(= PacketSS nil)
	      (setq PacketSS (ssadd))
	    )
					;(princ PacketO)
	    (setq PacketSS (ssadd e PacketSS))
	  )
	  (princ)
	)
	(setq ReverseNewcDataList nil)
					;(princ (assoc PacketN ReverseNewcDataList))
      )
    )
    (if	(= PacketSS nil)
      (princ "Nothing to see here!")
      (progn
	(command "zoom" "object" PacketSS "")
	(sssetfirst nil PacketSS)
      )
    )




;;;    (mapfilter
;;;      "#480 = #1 | #5025 = #56 | #39 = 972 | #39 = #1049 | #39 = 149"
;;;      ss
;;;      0
;;;      0
;;;      1
;;;     )					; filters selected set of item
;;;    (setq ss1 (ssget "_I"))		; creates a new set of items from the "implied set"
    (command "hideselected" PacketSS)

    (while (> (sslength PacketSS) 0)	;  loop that subtracts the bought out items ss1 from the original selection set ss
      (ssdel (ssname PacketSS 0) ss)
      (ssdel (ssname PacketSS 0) PacketSS)
    )
    (sssetfirst nil ss)
    (command "renumber" "a" "p" "" "")
    (command "showall" "")


    (while (> (sslength ss) 0)		; loop that adds additional SR items to the set, if no more items wanted, enter to move on
      (ssadd (ssname ss 0) oss)
      (ssdel (ssname ss 0) ss)
    )

    (initget 0 "Yes No")
    (setq ans (getkword "\nDo you want to pick another system? <Y> "))
    (if	(= ans "No")
      (setq loop 0)
    )
  )
  (executescript "zLisp-CAMprocess-2.cod" ssall)
;;;  (sssetfirst nil oss)
;;;  (command "createcam" oss)

  (princ "Ductwork has been renumbered... Please use Quick Filter to determine what is included for .MAJ file to CAM.")
)

;;;;;;;;;;;;;;;;;;;;;;

(defun DumpList	(e / ent field fieldnew Reversefield)
					;(setq ent (e))
  (setq vla (vlax-ename->vla-object e))
  (setq cData (vlax-get-property vla "CustomData"))
  (setq cDataList (str2lst cData "," T))
  (foreach field cDataList
    (progn
      (setq field (vl-string-subst "=" " = " field))
      (setq fieldnew (str2lst field "=" T))
      (setq NewcDataList (cons fieldnew NewcDataList))
      (setq Reversefield (reverse fieldnew))
      (setq ReverseNewcDataList
	     (cons Reversefield ReverseNewcDataList)
      )
    )
  )
  (reverse NewcDataList)
					;(princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun str2lst (strg delim trim / templist pos)
  (if trim
    (setq strg (vl-string-trim delim strg))
  )
  (setq templist (list))
  (while (setq pos (vl-string-search delim strg))
    (setq templist (cons (substr strg 1 pos) templist)
	  strg	   (substr strg (+ 2 pos))
    )
  )
  (reverse (cons strg templist))
)

















