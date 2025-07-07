; extends
(object
  (pair
    key: (_) @entry.lhs
    value: (_) @entry.inner @entry.rhs) @entry.outer)

(class_declaration
  body: (class_body)) @class.outer

(class_declaration
  body: (class_body
    .
    "{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "class.inner" @_start @_end)))

