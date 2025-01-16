(define-module (unification)
  #:use-module (pattern-match-utils)
  #:export (occurs-check subst-bindings unify unifier))

(define *debug* #f)
(define *occurs-check* #t)

(define (occurs-check var x bindings)
  "Does var occur anywhere inside x?"
  (cond
   ((equal? var x) #t)
   ((and (var? x)
	 (get-binding x bindings))
    (occurs-check var (lookup x bindings) bindings))
   ((pair? x)
    (or (occurs-check var (car x) bindings)
	(occurs-check var (cdr x) bindings)))
   (else #f)))

;; substitution
(define (subst-bindings bindings x)
  "Substitute the value of variables in bindings into x,
   taking recursively bound variables into account."
  (cond
   ((equal? bindings fail) fail)
   ((equal? bindings no-bindings) x)
   ((and (var? x)
	 (get-binding x bindings))
    (subst-bindings bindings (lookup x bindings)))
   ((not (pair? x)) x)
   (else (cons (subst-bindings bindings (car x))
	       (subst-bindings bindings (cdr x))))))

(define (unify-variable var x bindings)
  "Unify var with x, using (and maybe extending) bindings."
  (when *debug*
    (format #t "[unify-variable] var: ~a, x: ~a, bindings: ~a\n" var x bindings))
  (cond
   ((get-binding var bindings)
    (unify (lookup var bindings) x bindings))
   ((and (var? x)
	 (get-binding x bindings))
    (unify var (lookup x bindings) bindings))
   ((and *occurs-check*
	 (occurs-check var x bindings))
    fail)
   (else (extend-bindings var x bindings))))

(define (unify x y . optional-bindings)
  "See if x and y match with given bindings."
  (let ((bindings (if (null? optional-bindings)
		      no-bindings
		      (car optional-bindings))))
    (when *debug*
      (format #t "[unify] x: ~a, y: ~a, optional: ~a\n" x y optional-bindings))
    (cond
     ((equal? bindings fail) fail)
     ((equal? x y) bindings)
     ((var? x) (unify-variable x y bindings))
     ((var? y) (unify-variable y x bindings))
     ((and (pair? x)
	   (pair? y))
      (unify (cdr x)
	     (cdr y)
	     (unify (car x) (car y) bindings)))
     (else fail))))

(define (apply-unifier x y)
  "Return someting that unifies with both x and y (or fail)."
  (subst-bindings (unify x y) x))
