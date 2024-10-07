(directive) @function
(directive_start) @function
(directive_end) @function
; ((parameter) @include (#set! "priority" 110))
; ((php_only) @include (#set! "priority" 110))
((bracket_start) @function (#set! "priority" 120))
((bracket_end) @function (#set! "priority" 120))
((comment) @comment (#set! "priority" 130))
(keyword) @function
