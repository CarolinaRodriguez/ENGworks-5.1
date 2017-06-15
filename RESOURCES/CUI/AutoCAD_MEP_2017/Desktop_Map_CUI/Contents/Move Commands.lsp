
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
 

