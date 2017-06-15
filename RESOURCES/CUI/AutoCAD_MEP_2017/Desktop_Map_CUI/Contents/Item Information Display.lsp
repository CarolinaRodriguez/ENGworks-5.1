(defun c:OD (/)
  (vl-load-com)
  (vlax-dump-object
    (vlax-ename->vla-object (car (nentsel)))
  )
  (textscr)
  (princ)
)
