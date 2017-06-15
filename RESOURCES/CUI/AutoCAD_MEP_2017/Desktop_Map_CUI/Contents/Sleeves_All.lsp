
(defun C:slvall (/		     objX	    objY	   objZ		  objCurrentPoints		objCurrentPointsList
	      mspace	     thename	    theblock	   dwg		  ss		 len		cnt
	      zz	     objCurrentDesc objCurrentLayer		  LayName	 objCurrentService
	     )

  (vl-load-com)
  (setq	dwg (vla-get-activedocument
	      (vlax-get-acad-object)
	    )
  )
  (setq mspace (vla-get-modelspace dwg))
  (setq util (vla-get-utility dwg))
  (setq thename "bw_cp")
  (setq ss (ssget))
  (if ss
    (progn
      (setq len	(sslength ss)
	    cnt	0
      )
      (while (< cnt len)
	(setq e (ssname ss cnt))
	(setq objName (vlax-Ename->Vla-Object (ssname ss cnt)))
	(setq objCurrentPoints	(vlax-get-property objName "Points")
	      objCurrentDesc	(vlax-get-property objName "Description")
	      objCurrentLayer	(vlax-get-property objName "Layer")
	      objCurrentService	(vlax-get-property objName "ServiceName")
	)
	(getPoints) ;runs getPoints function
	(getLineSize)
;;; new code
;;;figure object size code below. extract description, check layer, add to description if insulated, return size with slv_## (2" with 2" insul is a slv_4) | PP-DHWR (CU)

	(cond
          ((<= lineSize 1.499) (setq thename "slv_2"))
	  ((<= lineSize 2.499) (setq thename "slv_2"))
	  ((<= lineSize 3.499) (setq thename "slv_3"))
	  ((<= lineSize 5.999) (setq thename "slv_4"))
	  ((<= lineSize 7.999) (setq thename "slv_6"))
	  ((<= lineSize 9.999) (setq thename "slv_8"))
	  ((<= lineSize 11.999) (setq thename "slv_10"))
	  ((<= lineSize 13.999) (setq thename "slv_15"))
	  ((<= lineSize 15.999) (setq thename "slv_20"))
	  (t nil)
	)

;;; end new code
	(setq theblock (vla-InsertBlock mspace (vlax-3D-point (list objX objY objZ)) thename 1 1 1 0))
	(setq zz (entlast))
	(vla-explode (vlax-ename->vla-object (entlast)))
	(entdel zz)
	(layerControl) ;runs layerControl function
	(setq cnt (+ cnt 1))
      ) ; while
    ) ; progn
  ) ;

  (princ)
) ;defun

 ;slv_2, 3, 4, 6, 8
 ; [ 4 ]"
 ; [ 1-1/4 ]"
 ;Type L Hard Copper [ 1/2 ]
 ;if layer = PDCW, PDHW, PDHWR, PNP then size = +##

 ;(prompt (strcat "\nInserted " (itoa len) " Blocks on current Layer."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getPoints ()
 ;  (setq objCurrentPoints (vlax-get-property objName "Points")) ;probably remove this line as it is in the main program now
  (setq objCurrentPoints (vl-string-subst "," ";" objCurrentPoints))
  (if (vl-string-search ";" objCurrentPoints)
    (setq objCurrentPoints (vl-string-right-trim ";" objCurrentPoints))
  )
  (setq objCurrentPoints (vl-string-trim "ENDPOINTS: " objCurrentPoints))
  (setq objCurrentPointsList (acet-str-to-list "," objCurrentPoints))
  (setq	objX (atof (car objCurrentPointsList))
	objY (atof (cadr objCurrentPointsList))
 ;objZ (atof (caddr objCurrentPointsList))
	;objZ 216 ;Level 1->Level 2 - 0'-0"
	objZ 748  ;Level 2->Level 3 - 0'-0" 
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun layerControl ()
 ;  (setq objCurrentLayer (vlax-get-property objName "Layer")) ;probably remove this as I put it in in main program
 ;(setq LayName (strcat "BAM_CP_" objCurrentLayer))
  (setq LayName (strcat "SLV_" objCurrentLayer))
  (if (= (tblsearch "LAYER" LayName) nil)
    (CreateLayer LayName)
  )
  
  (setq tempEnt (entlast))
  (entdel tempEnt)
  (setq curEnt (entlast))
  (entdel tempEnt)
  
  (vla-put-layer
    (vlax-ename->vla-object curEnt)
    (if	(tblsearch "LAYER" LayName)
      LayName
      (progn
	(vla-add (vla-get-layers
		   (vla-get-activedocument (vlax-get-acad-object))
		 )
		 LayName
	)
	LayName
      )
    )
  )
    (vla-put-layer
    (vlax-ename->vla-object (entlast))
    (if	(tblsearch "LAYER" LayName)
      LayName
      (progn
	(vla-add (vla-get-layers
		   (vla-get-activedocument (vlax-get-acad-object))
		 )
		 LayName
	)
	LayName
      )
    )
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getLineSize ()
  (setq lineSize (vl-string-right-trim "] " (substr objCurrentDesc (+ 3 (vl-string-search "[" objCurrentDesc)))))
  (if (= lineSize "2-1/2")
    (setq lineSize 2.5)
  )
  (if (= lineSize "1-1/2")
    (setq lineSize 1.5)
  )
  (if (= lineSize "1-1/4")
    (setq lineSize 1.25)
  )
  (if (= lineSize "3/4")
    (setq lineSize 0.75)
  )
  (if (= lineSize "1/2")
    (setq lineSize 0.5)
  )

  (if (not (NUMBERP lineSize))
    (setq lineSize (atof lineSize))
  )
  (if (OR (= objCurrentService "PP-DHWR (CU)")
	  (= objCurrentService "PP-DHW (CU)")
	  (= objCurrentService "PP-NP (CU)")
      )
    (progn
      (if (>= lineSize 1.5)
	(setq lineSize (+ 2 lineSize))
      )
      (if (<= lineSize 1.25)
	(setq lineSize (+ 2 lineSize))
      )

    )
  )
  ;;comment this out because DCW does not have insulation
;;;  (if (= objCurrentService "PP-DCW (CU)")
;;;    (setq lineSize (+ 2 lineSize))
;;;  )

(if (OR	(= objCurrentService "VENT (NH)")
	(= objCurrentService "SSAG (NH)")
    )
  (progn
    (if	(= lineSize 2)
      (setq lineSize (+ 0.35 lineSize))
    )
    (if	(= lineSize 3)
      (setq lineSize (+ 0.35 lineSize))
    )
    (if	(= lineSize 4)
      (setq lineSize (+ 0.38 lineSize))
    )
    (princ lineSize)
  )
)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:qg ()
  (setq e (entsel))
  (setq objName (vlax-Ename->Vla-Object (car e)))
  (vlax-dump-object objName T)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;(defun CreateLayer (newLayerName newLayerColor newLayerLT newLayerWT)
(defun CreateLayer (newLayerName)
  (entmake (list (cons 0 "LAYER")
		 (cons 100 "AcDbSymbolTableRecord")
		 (cons 100 "AcDbLayerTableRecord")
		 (cons 2 newLayerName ;| layer name |;)
 ;		 (cons 62 newLayerColor ;| color |;)
 ;		 (cons 6 newLayerLT ;| linetype |;)
 ;		 (cons 370 newLayerWT ;| linewight |;)
		 (cons 70 0)
	   )
  )
)
