(use-modules (pattern-match-utils)
	     (srfi srfi-64))

(test-begin "var?")
(test-equal #t (var? '?x))
(test-equal #f (var? 'x))
(test-end "var?")


(test-begin "get-binding")
(test-equal '(?x . ?y) (get-binding '?x '((?x . ?y) (?z . 1))))
(test-equal #f (get-binding '?a '((?x . ?y) (?z . 1))))
(test-end "get-binding")


(test-begin "binding-val")
(test-equal 1 (binding-val '(?a . 1)))
(test-end "binding-val")


(test-begin "lookup")
(test-equal 1 (lookup '?x '((?x . 1) (?y . 2))))
(test-end "lookup")


(test-begin "extend-bindings")
(test-equal '((?y . 2) (?x . 1)) (extend-bindings '?y 2 '((?x . 1))))
(test-end "extend-bindings")
