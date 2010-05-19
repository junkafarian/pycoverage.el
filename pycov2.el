(require 'linum)

(defvar pycov2-data nil "Coverage data for the buffer")
(make-variable-buffer-local 'pycov2-data)

(define-minor-mode pycov2-mode
  "Allow annotating the file with coverage information"
  :lighter " pycov "
  (if pycov2-mode
      (progn
        ;; (add-hook 'after-change-function 'pycov2-on-change nil t)
        (setf linum-format 'pycov2-line-format)
        (pycov2-on-change-force))
    (setf linum-format 'dynamic)
    (remove-hook 'after-change-functions 'pycov2-on-change t)))


(defun pycov2-on-change-force (&optional beg end len)
  (pycov2-on-change beg end len t))

(defun pycov2-on-change (&optional ben end len force)
  (let* ((result (pycov2-get-data (buffer-file-name)))   
   )))

(defun pycov2-line-format (line)
  (multiple-value-bind (face str coverage)
      (pcyov2-line-format line))
  )

(defun pycov2-get-data (filename)
  (let* ((result (pycov2-run-script filename))
         )
    (setq pycov2-data nil)
    (mapcar (lambda (line)
              (if (not (equal line ""))
                  (pycov2-process-script-line line)
                )
              ) (split-string result "[\n]+"))
    )
  )

(defun pycov2-process-script-line (line)
  ;; line looks like this filepath:103:MISSING
  (let*
      ((data (split-string line ":"))
       (path (first data))
       (number (string-to-number (second data)))
       (status (third data))
       )
    (when (equal status "MISSING")
      ;; add linenum to pycov2-data
      (add-to-list 'pycov2-data number)
      )
    )
  )

(defun pycov2-line-format (linenum)
  ;; if linenum in pycov2-data
  (if (member linenum pycov2-data)
      (propertize " " 'face '(:background "red" :foreground "red"))
    (propertize " " 'face '())
    )
  )

(defun pycov2-run-script (filename)
  (shell-command-to-string (format "PYTHONPATH=/Users/junkafarian/.emacs.d/plugins/pycoverage/cov2emacs/ /Users/junkafarian/.emacs.d/plugins/pycoverage/cov2emacs/bin/cov2emacs --compile-mode --python-file %s 2>/dev/null"
                                   filename)))

(provide 'pycov2)
