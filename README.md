
# moondoc

`moondoc` is a command line tool that parses a MoonScript file and returns a
Lua file with metadata about the classes, functions, and constants exported.
It's designed to be part of a pipeline to generate documentation for MoonScript
projects.

It works by usingthe MoonScript parser to extract the AST, then it searches for
for near by comments to add additional metadata. Information is extracted
statically, without running the code, so dynamically generated parts might need
additional annotation.
