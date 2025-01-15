(define-module (pattern-match-utils)
  #:export (fail
	    no-bindings
	    var?
	    get-binding
	    binding-val
	    lookup
	    extend-bindings))

(define fail #f)
;; "Indicates pat-match success, with no variables."
(define no-bindings '((#t . #t)))

(define (var? x)
  "Is x a variable (a symbol beginning with '?')?"
  (and (symbol? x)
       ;; check symbol start with ?
       (char=? (string-ref (symbol->string x) 0) #\?)))

(define (get-binding var bindings)
  "Find a (variable . value) pair in a binding list."
  (assoc var bindings))

(define (binding-val binding)
  "Get the value part of a single binding."
  (cdr binding))

(define (lookup var bindings)
  "Get the value part (for var) from a binding list."
  (binding-val (get-binding var bindings)))

(define (extend-bindings var val bindings)
  "Add a (var . value) pair to a binding list."
  (cons (cons var val)
	(if (equal? bindings no-bindings)
	    '()
	    bindings)))
