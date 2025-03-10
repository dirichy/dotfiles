(comment) @comment

(punctuation) @punctuation

(
  (assignment_lhs)
  .
  (
    (punctuation) @operator
    (#match? @operator "^=$")
  )
)

(named_context
  (symbol)
  .
  (
    (punctuation) @operator
    (#match? @operator "^=$")
  )
  .
  [(symbol) (string)]
)

(chord
  .
  "<" @punctuation.bracket
  ">" @punctuation.bracket
  .
)

(
  (escaped_word) @function
  (#not-match? @function "^\\\\(include|maininput|version)$") ; This is needed for Panic Nova
)
(
  (escaped_word) @processing
  (#match? @processing "^\\\\(include|maininput|version)$") ; These are handled directly by LilyPond’s lexer.
)
(
  (escaped_word) @value.number
  (#match? @value.number "^\\\\(breve|longa|maxima)$")
)
(
  (escaped_word) @identifier.core.function
  (#match? @identifier.core.function "^\\\\\\^$")
)

(quoted_identifier
  "\"" @bracket
)

(
  (symbol) @keyword
  (#match? @keyword "^q$")
)

[
  (fraction)
  (decimal_number)
  (unsigned_integer)
] @value.number

(dynamic) @identifier.core.global

(instrument_string_number) @identifier.core.function

(
  (string
    "\"" @string.delimiter.left
    [
      (string_fragment)?
      (escape_sequence)? @string.escape
    ]
    "\"" @string.delimiter.right
  )
) @string

[
  "{" "}"
  "<<" (parallel_music_separator) ">>"
  "#{" "#}"
] @punctuation.bracket

(chord
  ">>" @invalid
)

(embedded_scheme_prefix) @processing

[
  (scheme_comment)
] @comment

(
  (scheme_symbol) @operator
  (#match? @operator "^([*+/=<>-]|[<>]=)$")
)

(
  (scheme_string
    "\"" @delimiter
    [
      (scheme_string_fragment)?
      (scheme_escape_sequence)? @string.escape
    ]
    "\"" @delimiter
  )
) @string

(scheme_keyword
  "#:" @punctuation
  (scheme_keyword_name) @identifier
)

(scheme_boolean) @boolean

(scheme_number) @number

(scheme_character) @entity

(scheme_quote . "'" @operator)
(scheme_quasiquote . "`" @operator)
(scheme_unquote . "," @operator)
(scheme_unquote_splicing . ",@" @operator)

[
  "(" ")"
  "#{" "#}"
] @punctuation.bracket
