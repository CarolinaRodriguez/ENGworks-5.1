;;Copy Design Line Sets
(defun c:CDLS ()
  (command "CPYDLSEL")
  (princ)
)

;;Edit Designline Objects
(defun c:EDOS ()
  (command "CHDOBJ")
  (princ)
)

;;Erase 3d Design Line elements
(defun c:E3DDI ()
  (command "ERASE3DDITEMS")
  (princ)
)

;;Revise Designline
(defun c:RDLS ()
  (command "Revdesign")
  (princ)
)

;;Fill design lines 
(defun c:FDLS ()
  (command "fill3ditems")
  (princ)
)

;;adddesignlines
(defun c:adddls ()
  (command "adddesignlines")
  (princ)
)

;;DELETE NODES
(defun c:DDLNS ()
  (command "adddesignlines")
  (princ)
)