(defun c:scc (/ ss)
  (command "insert" "Sanitary_cross" (getpoint "\nSelect insertion point: ") "1" "0" "0")
  (princ)
)