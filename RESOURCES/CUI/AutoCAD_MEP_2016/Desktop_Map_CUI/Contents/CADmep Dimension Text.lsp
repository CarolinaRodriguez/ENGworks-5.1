;Lisp Routine for adding text to dimensions

(Defun c:fv ()
(setq newdim (entsel "\n Select Dimension to Add FIELD VERIFY to:"))
(setq newdimvalue "<>\\X FIELD VERIFY")
(command "dimedit" "n" newdimvalue newdim "")
(princ)
)

(Defun c:cencen ()
(setq newdim (entsel "\n Select Dimension to Add C-C to:"))
(setq newdimvalue "<>\\X C-C")
(command "dimedit" "n" newdimvalue newdim "")
(princ)
)

(Defun c:ec ()
(setq newdim (entsel "\n Select Dimension to Add E-C to:"))
(setq newdimvalue "<>\\X E-C")
(command "dimedit" "n" newdimvalue newdim "")
(princ)
)

(Defun c:fc ()
(setq newdim (entsel "\n Select Dimension to Add F-C to:"))
(setq newdimvalue "<>\\X F-C")
(command "dimedit" "n" newdimvalue newdim "")
(princ)
)

(Defun c:ff ()
(setq newdim (entsel "\n Select Dimension to Add F-F to:"))
(setq newdimvalue "<>\\X F-F")
(command "dimedit" "n" newdimvalue newdim "")
(princ)
)

(Defun c:ee ()
(setq newdim (entsel "\n Select Dimension to Add E-E to:"))
(setq newdimvalue "<>\\X E-E")
(command "dimedit" "n" newdimvalue newdim "")
(princ)
)

(Defun c:ef ()
(setq newdim (entsel "\n Select Dimension to Add E-F to:"))
(setq newdimvalue "<>\\X E-F")
(command "dimedit" "n" newdimvalue newdim "")
(princ)
)



