;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "with-editor" "20260924.937"
  "Use the Emacsclient as $EDITOR."
  '((emacs    "28.1")
    (compat   "31.0")
    (cond-let "1.1")
    (llama    "1.0"))
  :url "https://github.com/magit/with-editor"
  :commit "5e6b398c06609ad6b294b393d5af7fb6304b0d81"
  :revdesc "5e6b398c0660"
  :keywords '("processes" "terminals")
  :authors '(("Jonas Bernoulli" . "emacs.with-editor@jonas.bernoulli.dev"))
  :maintainers '(("Jonas Bernoulli" . "emacs.with-editor@jonas.bernoulli.dev")))
