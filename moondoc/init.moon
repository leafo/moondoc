
parse = require "moonscript.parse"

import pos_to_line from require "moonscript.util"
import types from require "tableshape"

t = (k) -> types.shape k, open: true

is_class = t { "class", types.string }
is_ref = t { "ref", types.string }
is_table = t { "table", types.table }
is_assign = t { "assign", types.table, types.table }
is_key_literal = t { "key_literal", types.string }

ref_to_string = (r) ->
  assert type(r[2]) == "string", "don't know how to convert ref"
  r[2]

assigns_by_name = (assign) ->
  assigns = {}

  for idx, name in ipairs assign[2]
    value = assign[3][idx]
    continue unless value

    name = if is_ref name
      ref_to_string name
    elseif types.string name
      name
    else
      continue

    assigns[name] = value

  assigns

format_stm = (node, more_props) ->
  return unless node
  out = switch node[1]
    when "fndef"
      {
        type: "function"
        :name
      }
    when "class"
      {
        type: "class"
        :name
      }

  if out
    if more_props
      for k,v in pairs more_props
        out[k] = v

    out

parse_exports = (file) ->
  f = assert io.open file
  file = f\read "*a"
  f\close!

  tree = assert parse.string file
  -- things available for export indexed by their name
  locals = {}

  for stm in *tree
    if is_class stm
      locals[stm[2]] = stm
    elseif is_assign stm
      assigns = assigns_by_name stm
      for k,v in pairs assigns
        locals[k] = v

  out = {}

  -- get the implicit return
  last = tree[#tree]

  if is_table last
    out.exports = {}
    for {key,value} in *last[2]
      continue unless is_key_literal key
      export_name = key[2]
      continue unless is_ref value
      local_name = value[2]
      print "export", export_name, local_name

      if export_value = locals[local_name]
        out.exports[export_name] = format_stm export_value, {
          name: export_name
          line_number: export_value[-1] and pos_to_line file, export_value[-1]
        }
  else
    -- exporting single thing
    error "not yet"

  out

{ :parse_exports }

