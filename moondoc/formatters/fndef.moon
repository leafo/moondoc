import format_stm from require "moondoc.format"
import types from require "tableshape"

is_method = types.shape {
  "fndef", types.table, types.table, "fat"
}, open: true

(node) ->
  arguments = {}
  raw_args = node[2]

  for {name, default} in *raw_args
    if default
      default = format_stm default

    table.insert arguments, {
      :name
      :default
    }

  {
    type: is_method(node) and "method" or "function"
    :arguments
  }
