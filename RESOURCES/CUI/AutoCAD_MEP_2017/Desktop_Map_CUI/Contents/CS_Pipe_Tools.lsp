(vl-load-com)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Storing System Variables
;;;  CS_SysVar
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun CS_SVars	(/ var)
  (setq CS_sysvars nil)
  (foreach v '("attdia"	      "blipmode"     "cmddia"
	       "cmdecho"      "filedia"	     "orthomode"
	       "osmode"	      "snapang"	     "elevation"
	      )
    (setq var (list (list v (getvar v))))
    (setq CS_sysvars (append CS_sysvars var))
  )
  (princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;     Restoring System Variables
;;;;
;;;;
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
(defun CS_RVars (/ var)
  (while CS_sysvars
    (setq var (car CS_sysvars))
    (setvar (car var) (cadr var))
    (setq CS_sysvars (cdr PT_sysvars))
  )
  (princ)
) 




(defun pipeinfo (entity  /	    	 endpt	    len
		   len1	      len2	 pipeendx   pipeendy
		   pipeendz   pipepts	 pipestartx pipestarty
		   pipestartz start	 startpt    vlaobj
		  )

;;;  (setq entity (car (entsel "Pick CADMEP Object:")))

  (setq	vlaobj	   (vlax-ename->vla-object entity)
	pipeelev   (vlax-get-property vlaobj 'elevation)
	pipeserv   (vlax-get-property vlaobj 'servicename)
	pipedesc   (vlax-get-property vlaobj 'description)
	pipepts	   (vlax-get-property vlaobj 'points)
	pipelayer  (vlax-get-property vlaobj 'layer)
	start	   (+ 3 (vl-string-search ": " pipepts))
	len	   (1+ (- (vl-string-search ";" pipepts start) start))
	startpt	   (substr pipepts start len)
	len1	   (vl-string-search "," startpt)
	len2	   (vl-string-search "," startpt (1+ len1))
	pipestartx
		   (substr startpt 1 len1)
	pipestarty
		   (substr startpt (+ 2 len1) (- len2 len1 1))
	pipestartz
		   (substr startpt (+ 2 len2))
	start	   (+ 1 len start)
	len	   (1+ (- (vl-string-search ";" pipepts start) start))
	endpt	   (substr pipepts start len)
	len1	   (vl-string-search "," endpt)
	len2	   (vl-string-search "," endpt (1+ len1))
	pipeendx   (substr endpt 1 len1)
	pipeendy   (substr endpt (+ 2 len1) (- len2 len1 1))
	pipeendz   (substr endpt (+ 2 len2))

	pipept1	   (trans (list	(distof pipestartx 2)
				(distof pipestarty 2)
				(distof pipestartz 2)
			  )
			  0
			  1
		   )			; end of trans
	pipept2	   (trans (list	(distof pipeendx 2)
				(distof pipeendy 2)
				(distof pipeendz 2)
			  )
			  0
			  1
		   )			; end of trans

  )
  (setq start (vl-string-search "[" pipedesc))
  (if (null start)
    (setq pipesize "Duct")
    (progn
      (setq start (+ 3 start))
      (setq len	     (- (vl-string-search "]" pipedesc) start)
	    pipesize (strcat (substr pipedesc start len) "\"")
	    pipesize (vl-list->string
		       (subst '32
			      '45
			      (vl-string->list pipesize)
		       )
		     )
      )
    )
  )
  (while (setq
	   sizestart (vl-string-search "|" pipelayer)
	 )
    (setq pipelayer (substr pipelayer (+ 2 sizestart)))
  )
  (if (setq sizestart (vl-string-search "[" pipedesc))
    (setq pipedesc (substr pipedesc 1 (- sizestart 1)))
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;            Pipe Annotation
;;;
;;;            Function: Adds Pipe Rack Text at a point selected on the screen and sets orientation to view
;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





(CS_SVars)
(defun c:rackanno (/ pt1 pt2 )
    (setq	pt1    (getpoint
		 "\nSelect by crossing, Top to Bottom or Left to Right. \nSelect first point: "
	       )							;; get points for fence; point 1
	pt2    (getpoint pt1 "\nNext point: ")				;; point 2
	ss     (ssget "_F" (list pt1 pt2) '((0 . "MAPS_SOLID")))	;; use fence filter and get selection order
	hang   (car (entsel "\nSelect Hanger or <enter> for none: "))	;; select hanger or not
	pnt    (getpoint "\nText Position: ")				;; prompt for text position
	Xcoord (car pnt)						;; get text X coordinate
	Ycoord (cadr pnt)						;; get text Y coordinate
	Zcoord (caddr pnt)						;; get text Z coordinate
	txtsz  (getvar "textsize")
	tmode  (getvar "tilemode")
	ent1   (ssname ss 0)
	)
  
  (pipeinfo ent1)
  (if (= tmode 1)
    (setq spacing 5.0)
  )									;; spacing between text rows
  (if (= tmode 0)
    (progn
    (setq vpscale (car (trans '(1 0 0)2 3 0)))
    (setq spacing (*(/ txtsz vpscale) 1.25))
    )
   )
  
  (while (> (sslength ss) 0)						;; loop thru selection set
    (setq ent (ssname ss 0))						;; get ename
    (addTextAtPoint 2 ent pnt)						;; add text
     (setq Ycoord (- Ycoord spacing)					;; compute next Ycoord
	  pnt	 (list Xcoord Ycoord Zcoord)				;; create next text point
     )
    (AlignMapText ss 2 "V")						;; check orientation of pipe using X coordinate, if they are equal, alignmaptext
    (ssdel ent ss)
   )
    (if hang								;; if hanger selected, add elevation
      (if (= tmode 1)
    	(addTextAtPoint 7 hang pnt "MS_Z-HangElev")
	(addTextAtPoint 7 hang pnt "PS_Z-HangElev")
      )	
    )
  (CS_RVars)
   (princ)
  )

