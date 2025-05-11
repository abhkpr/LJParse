;;; parser.lisp - Minimal JSON Parser in Common Lisp

(defpackage :json-parser
  (:use :cl)
  (:export :parse-json))

(in-package :json-parser)

(defun parse-json (json-string)
  "Main entry point for parsing JSON string to Lisp."
  (multiple-value-bind (value _) (parse-value (remove-whitespace json-string) 0)
    value))

(defun remove-whitespace (str)
  "Remove whitespace for easier parsing."
  (coerce (remove-if #'(lambda (c) (member c '(#\Space #\Tab #\Newline #\Return))) str) 'string))

(defun parse-value (str pos)
  (let ((char (char str pos)))
    (cond
      ((char= char #\") (parse-string str pos))
      ((char= char #\{) (parse-object str pos))
      ((char= char #\[) (parse-array str pos))
      ((or (digit-char-p char) (char= char #\-)) (parse-number str pos))
      ((string= (subseq str pos (+ pos 4)) "true") (values t (+ pos 4)))
      ((string= (subseq str pos (+ pos 5)) "false") (values nil (+ pos 5)))
      ((string= (subseq str pos (+ pos 4)) "null") (values nil (+ pos 4)))
      (t (error "Unexpected character at ~A: ~A" pos char)))))

(defun parse-string (str pos)
  (let ((end (position #\" str :start (1+ pos))))
    (values (subseq str (1+ pos) end) (1+ end))))

(defun parse-number (str pos)
  (let ((end pos))
    (loop while (and (< end (length str))
                     (or (digit-char-p (char str end))
                         (member (char str end) '(#\+ #\- #\. #\e #\E))))
          do (incf end))
    (values (read-from-string (subseq str pos end)) end)))

(defun parse-array (str pos)
  (let ((i (1+ pos))
        (result '()))
    (loop
      (multiple-value-bind (val next) (parse-value str i)
        (push val result)
        (setf i next)
        (case (char str i)
          (#\, (incf i))
          (#\] (return (values (nreverse result) (1+ i))))
          (t (error "Unexpected character in array: ~A" (char str i))))))))

(defun parse-object (str pos)
  (let ((i (1+ pos))
        (result '()))
    (loop
      (when (char= (char str i) #\}) 
        (return (values (nreverse result) (1+ i))))
      (multiple-value-bind (key next1) (parse-string str i)
        (setf i (1+ (position #\: str :start next1))) ; skip colon
        (multiple-value-bind (val next2) (parse-value str i)
          (push (cons key val) result)
          (setf i next2)
          (case (char str i)
            (#\, (incf i))
            (#\} (return (values (nreverse result) (1+ i))))
            (t (error "Unexpected character in object: ~A" (char str i)))))))))
