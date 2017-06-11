
import types from require "tableshape"

is_empty = types.shape {
  "table"
  types.shape { }
}, open: true

(node) ->
  { type: "table" }

