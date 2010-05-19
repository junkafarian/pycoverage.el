(require 'linum)

(defvar pycov2-data nil "Coverage data for the buffer")
(defvar pycov2-mode-text " pycov(I)")
(defvar pycov2-color-not-run "#ef2929")
(defvar pycov2-color-no-data "#fce94f")
(defvar pycov2-color-covered "")
(defvar cov2emacs-command "PYTHONPATH=/Users/junkafarian/.emacs.d/plugins/pycoverage/cov2emacs/ /Users/junkafarian/.emacs.d/plugins/pycoverage/cov2emacs/bin/cov2emacs")

(make-variable-buffer-local 'pycov2-mode-text)
(make-variable-buffer-local 'pycov2-data)
(make-variable-buffer-local 'pycov2-cov-file)
(make-variable-buffer-local 'cov2emacs-command)


(define-minor-mode pycov2-mode
  "Allow annotating the file with coverage information"
  :lighter pycov2-mode-text
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


(defun pycov2-refresh ()
  "reload data for buffer"
  (interactive )
  (pycov2-get-data (buffer-file-name) pycov2-cov-file) 
  )

(defun pycov2-rerun (cov_file)
  "reload data for buffer using specified coverage file"
  (interactive "FCoverage file:")
  (setq pycov2-cov-file cov_file)
  (pycov2-get-data (buffer-file-name) cov_file) 
  )
(defun pycov2-get-data (filename &optional cov_file )
  (let* ((result (pycov2-run-better filename cov_file))
         )
    (setq pycov2-data nil)
    (message "RESULT")
    (message result)
    (message "RESULT2")
    (if result
        (mapcar (lambda (line)
                  (if (not (equal line ""))
                      (pycov2-process-script-line line)
                    )
                  ) (split-string result "[\n]+"))
      )

    )
  ;; update mode-line
  (setq pycov2-mode-text " pycov")
  (force-mode-line-update)
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

;; (defun pycov2-line-format (line)
;;   (multiple-value-bind (face str coverage)
;;       (pcyov2-line-format line))
;;   )
(defun pycov2-line-format (linenum)
  ;; if linenum in pycov2-data
   (if (member linenum pycov2-data)
          (propertize (format "%4d " linenum) 'face '(:background "#ef2929" :foreground "grey10"))
          (propertize (format "%4d " linenum) 'face '(:background " " :foreground " "))
          )
        )
  )

(defun pycov2-run-better (filename &optional cov_file)
  (let*
      (
       (command (if cov_file
                    ( format "%s --compile-mode --python-file %s --coverage-file %s" cov2emacs-command filename cov_file)
                  ( format "%s --compile-mode --python-file %s" cov2emacs-command filename)
                  )))
    (message command)
    (shell-command-to-string command)
    )
  )

;; old run command
;; (defun pycov2-run-script (filename)
;;   (shell-command-to-string (format "%s --compile-mode --python-file %s 2>/dev/null"
;;                                    cov2emacs-command filename)))

(provide 'pycov2)
