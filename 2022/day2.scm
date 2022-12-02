; Run with CHICKEN Scheme

(import (chicken io)
        (chicken string))

(define input (map string-split (with-input-from-file "day2.txt" read-lines)))

(define A "A")

(define (parse-given value)
    (case value
        ((A) 'R)
        ((B) 'P)
        ((C) 'S)))

(define (parse-right-part-1 value)
    (case value
        ((X) 'R)
        ((Y) 'P)
        ((Z) 'S)))

(define (parse-pair pair)
    (cons (parse-given (string->symbol (car pair))) (string->symbol (car (cdr pair)))))

(define parsed (map parse-pair input))

(define (score-choice choice)
    (case choice
        ((R) 1)
        ((P) 2)
        ((S) 3)))

(define (beats? self opponent)
    (case self
        ((R) (eq? opponent 'S))
        ((P) (eq? opponent 'R))
        ((S) (eq? opponent 'P))))

(define (score-match self opponent)
    (cond
        ((beats? self opponent) 6) ; Win
        ((eq? self opponent) 3) ; Draw
        (else 0))) ; Loss

(define (score-pair self opponent)
    (+ (score-choice self) (score-match self opponent)))

(define (score-part-1 pair)
    (score-pair (parse-right-part-1 (cdr pair)) (car pair)))

(print (conc "Part 1: " (apply + (map score-part-1 parsed))))

(define (choose-shape opponent desired-outcome)
    (case desired-outcome
        ((X) (case opponent ; Need to lose
            ((R) 'S)
            ((P) 'R)
            ((S) 'P)))
        ((Y) opponent) ; Need to draw
        ((Z) (case opponent ; Need to win
            ((R) 'P)
            ((P) 'S)
            ((S) 'R)))))

(define (score-part-2 pair)
    (define opponent (car pair))
    (define desired-outcome (cdr pair))

    (score-pair (choose-shape opponent desired-outcome) opponent))

(print (conc "Part 2: " (apply + (map score-part-2 parsed))))
