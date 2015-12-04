#lang racket

(define (read-input filename)
  (let ((str (file->string filename)))
    (string->list str)))

(define (select-members path pred)
  (let loop ((selected '())
             (counter 1)
             (remaining path))
    (cond ((null? remaining)
           (reverse selected))
          ((pred counter)
           (loop (cons (car remaining) selected)
                 (add1 counter)
                 (cdr remaining)))
          (#t
           (loop selected
                 (add1 counter)
                 (cdr remaining))))))

(define (path->coords path)
  (let loop ((cx 0)
             (cy 0)
             (visited '((0 0)))
             (remaining path))
    (cond ((null? remaining)
           (reverse visited))
          ((equal? (car remaining) #\^)
           (loop cx (add1 cy) (cons (list cx (add1 cy)) visited) (cdr remaining)))
          ((equal? (car remaining) #\<)
           (loop (sub1 cx) cy (cons (list (sub1 cx) cy) visited) (cdr remaining)))
          ((equal? (car remaining) #\>)
           (loop (add1 cx) cy (cons (list (add1 cx) cy) visited) (cdr remaining)))
          ((equal? (car remaining) #\v)
           (loop cx (sub1 cy) (cons (list cx (sub1 cy)) visited) (cdr remaining)))
          (#t
           (loop cx cy visited (cdr remaining))))))

(define (unique-houses path)
  (length (remove-duplicates path
                             (lambda (house1 house2)
                               (and (= (car house1) (car house2))
                                    (= (cadr house1) (cadr house2)))))))

(define path (read-input "3-data.txt"))

(print (unique-houses (path->coords path)))
(newline)
(print (unique-houses (append (path->coords (select-members path odd?))
                              (path->coords (select-members path even?)))))
