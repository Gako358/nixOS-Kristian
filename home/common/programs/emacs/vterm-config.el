;; vterm
(require 'vterm)
(defun project-vterm ()
  (interactive)
  (let* ((default-directory (project-root (project-current t)))
         (vterm-buffer-name "*vterm*")
         (vterm-buffer (get-buffer vterm-buffer-name)))
    (if (and vterm-buffer (not current-prefix-arg))
        (pop-to-buffer vterm-buffer)
      (vterm))))

