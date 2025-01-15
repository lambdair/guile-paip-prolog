(use-modules (unification)
	     (srfi srfi-64))

(test-begin "occurs-check")
(test-equal #f (occurs-check '?x '?y '((?x . 1))))
(test-equal #t (occurs-check '?x '?x '()))
(test-equal #t (occurs-check '?x '(f ?x g) '()))
(test-equal #t (occurs-check '?x '?y '((?y . ?x))))
(test-end "occurs-check")


(test-begin "subst-bindings")
(test-equal 1 (subst-bindings '((?x . 1)) '?x))
(test-equal '(1 + b) (subst-bindings '((?x . 1) (?y . b)) '(?x + ?y)))
(test-equal 'b (subst-bindings '((?x . ?y) (?y . b)) '?x))
(test-equal '(f a b c) (subst-bindings '((?x . a)) '(f a b c)))
(test-equal #f (subst-bindings fail '(?x + ?y)))
(test-end "subst-bindings")


(test-begin "unify")
(test-equal '((?y . a) (?x . ?y)) (unify '(?x ?y a) '(?y ?x ?x)))
(test-equal #f (unify '?x '(f ?x)))
(test-equal #f (unify '(?x ?y) '((f ?y) (f ?x))))
(test-equal #f (unify '(?x ?y ?z) '((?y ?z) (?x ?z) (?x ?y))))
(test-equal '((#t . #t)) (unify 'a 'a))
(test-end "unify")


(test-begin "unifier")
(test-equal '(a a a) (unifier '(?x ?y a) '(?y ?x ?x)))
(test-equal '((?a * 5 ^ 2) + (4 * 5) + 3)
             (unifier '((?a * ?x ^ 2) + (?b * ?x) + ?c)
	              '(?z + (4 * 5) + 3)))
(test-end "unifier")
