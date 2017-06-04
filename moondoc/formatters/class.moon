import format_stm from require "moondoc.format"

import types from require "tableshape"
is_props = types.shape { "props" }, open: true
is_key_literal = types.shape { "key_literal", types.string }, open: true
is_self = types.shape { "self", types.string }, open: true

is_function = types.shape { "fndef" }, open: true

is_method = types.shape {
  "props"
  types.shape {
    is_key_literal
    is_function
  }
}

is_class_method = types.shape {
  "props"
  types.shape {
    is_self
    is_function
  }
}

(node) ->
  -- TODO: extract fields
  contents = node[4]

  methods = {}
  class_methods = {}

  for p in *contents
    add_item = (list, p) ->
      { key, value } = p[2]
      property_name = key[2]

      formatted = format_stm value, {
        name: property_name
      }

      table.insert list, formatted

    if is_method p
      add_item methods, p

    if is_class_method p
      add_item class_methods, p

  {
    type: "class"
    :methods
    :class_methods
  }
