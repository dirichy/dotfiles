;; extends

((generic_command
   (command_name) @cmdname ) @injection.content
 (#eq? @cmdname "\\mathbb")
 (#set! injection.language "latexconceal")
 (#set! injection.include-children)
)
