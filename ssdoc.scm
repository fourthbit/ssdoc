#!/usr/bin/env gsi-script

;;!!! SSDoc documentation system for SchemeSpheres
;; .author Alvaro Castro-Castilla, 2014

;; Debugging notes:
;; 1) Uncomment shebang line
;; 2) Comment the last line to avoid running main twice

(include "arguments.scm")
(include "minimal.scm")



(define *help:general* #<<end-help-string

Usage: ssdoc [command] [operand]

Commands:
    search [string] [flags]
        search the documentation for functions and des
        -f Include functions in search (default if nothing else)
        -d Include descriptions in search
    generate [flags]
        generate documentation for local libraries
        -p List of paths separated by colon (:)
    update (not implemented)
        pull an updated documentation file of all packages 

end-help-string
)

;; Flag listing
;; 1 means that takes an argument, 0 it doesn't
(define *options*
  '((#\f 0 "functions")
    (#\d 0 "descriptions")
    (#\p 1 "paths")))

;; Command: HELP
(define (help-cmd cmd opts args)
  (define help-topics
    `(("search" ,@*help:general*)
      ("generate" ,@*help:general*)
      ("update" ,@*help:general*)))
  (define num-args (length args))
  (handle-opts! opts `(("help" ,@(lambda (val) #t))))
  (cond
   ((zero? num-args) (println *help:general*))
   ((= 1 num-args)
    (let* ((arg (car args))
           (res (assoc arg help-topics)))
      (if res
          (println (cdr res))
          (die/error "Unknown help topic:" arg))))
   (else
    (die/error "Invalid arguments passed to help:" args))))

;; Command: SEARCH
(define (search-cmd cmd opts args)
  'search)

;; Command: GENERATE
(define (generate-cmd cmd opts args)
  'generate)

;; Command: UPDATE
(define (update-cmd cmd opts args)
  'update)

;; Command Unknown
(define (unknown-cmd cmd opts args-sans-opts)
  (die/error "Unknown command:"
             cmd "-- To get a list of options, type 'ssdoc help'"))

(define (main . args)
  (let ((commands
         `(("help" ,@help-cmd)
           ("search" ,@search-cmd)
           ("generate" ,@generate-cmd)
           ("update" ,@update-cmd)
           ("unknown-command" ,@unknown-cmd))))
    (parse-arguments
     args
     (lambda (actual-args-sans-opts opts)
       (let* ((args-sans-opts (if (null? actual-args-sans-opts)
                                  '("help")
                                  actual-args-sans-opts))
              (cmd-pair (assoc (car args-sans-opts) commands))
              (cmd (if cmd-pair
                       (cdr cmd-pair)
                       (cdr (assoc "unknown-command" commands)))))
         (cmd (car args-sans-opts)
              opts
              (cdr args-sans-opts))))
     *options*)))

;;(apply main (cdr (command-line)))

