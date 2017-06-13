
parse = require "moonscript.parse"

loadkit = require "loadkit"

import pos_to_line from require "moonscript.util"
import types from require "tableshape"
import format_stm from require "moondoc.format"

t = (k) -> types.shape k, open: true

is_class = t { "class", types.string }
is_ref = t { "ref", types.string }
is_table = t { "table", types.table }
is_assign = t { "assign", types.table, types.table }
is_key_literal = t { "key_literal", types.string }

ref_to_string = (r) ->
  assert type(r[2]) == "string", "don't know how to convert ref"
  r[2]

class Buffer
  new: (@buffer) =>

  pos_to_line: (pos) =>
    return nil unless pos
    pos_to_line @buffer, pos

  get_proceeding_comment: (pos) =>

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

-- a quick helper to test format statements
parse_expresion = (code) ->
  tree = assert parse.string code
  exp = assert unpack(tree), "missing expression"
  format_stm exp

parse_module = (code, opts={}) ->
  buffer = Buffer code

  tree = assert parse.string code
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
    out.type = "table"
    out.exports = {}
    for {key,value} in *last[2]
      continue unless is_key_literal key
      export_name = key[2]
      continue unless is_ref value
      local_name = value[2]

      if export_value = locals[local_name]
        formatted = format_stm export_value, {
          name: export_name
          line_number: buffer\pos_to_line export_value[-1]
        }

        continue unless formatted
        table.insert out.exports, formatted

  else
    -- exporting single thing
    error "not yet"

  out

filename_for_module = (module_name) ->
  loader = loadkit.make_loader "moon", nil, "./?.lua"
  assert loader module_name

parse_module_by_name = (module_name, fname) ->
  fname or= filename_for_module module_name

  f = assert io.open fname
  file = f\read "*a"
  f\close!

  out = parse_module file
  out.name = module_name
  out

shell_escape = (str) ->
  str\gsub "'", "''"

scan_for_modules = (dir=".") ->
  f = assert io.popen "find '#{shell_escape dir}' -type f -iname '*.moon' -print0"
  files = f\read "*a"

  out = for file in files\gmatch "[^%z]+"
    module_name = file\gsub("^%./", "")\gsub("%.moon$", "")\gsub "/", "."

    -- trim init module
    if module_name\match "%.init$"
      module_name = module_name\sub 1, -(#".init" + 1)

    { file, module_name }

  table.sort out, (a,b) ->
    a[2] < b[2]

  out

{ :parse_module, :parse_expresion, :parse_module_by_name, :scan_for_modules }

