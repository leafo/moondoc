local parse = require("moonscript.parse")
local pos_to_line
pos_to_line = require("moonscript.util").pos_to_line
local types
types = require("tableshape").types
local t
t = function(k)
  return types.shape(k, {
    open = true
  })
end
local is_class = t({
  "class",
  types.string
})
local is_ref = t({
  "ref",
  types.string
})
local is_table = t({
  "table",
  types.table
})
local is_assign = t({
  "assign",
  types.table,
  types.table
})
local is_key_literal = t({
  "key_literal",
  types.string
})
local ref_to_string
ref_to_string = function(r)
  assert(type(r[2]) == "string", "don't know how to convert ref")
  return r[2]
end
local assigns_by_name
assigns_by_name = function(assign)
  local assigns = { }
  for idx, name in ipairs(assign[2]) do
    local _continue_0 = false
    repeat
      local value = assign[3][idx]
      if not (value) then
        _continue_0 = true
        break
      end
      if is_ref(name) then
        name = ref_to_string(name)
      elseif types.string(name) then
        name = name
      else
        _continue_0 = true
        break
      end
      assigns[name] = value
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  return assigns
end
local format_stm
format_stm = function(node, more_props)
  if not (node) then
    return 
  end
  local out
  local _exp_0 = node[1]
  if "fndef" == _exp_0 then
    out = {
      type = "function",
      name = name
    }
  elseif "class" == _exp_0 then
    out = {
      type = "class",
      name = name
    }
  end
  if out then
    if more_props then
      for k, v in pairs(more_props) do
        out[k] = v
      end
    end
    return out
  end
end
local parse_exports
parse_exports = function(code, opts)
  if opts == nil then
    opts = { }
  end
  local tree = assert(parse.string(code))
  local locals = { }
  for _index_0 = 1, #tree do
    local stm = tree[_index_0]
    if is_class(stm) then
      locals[stm[2]] = stm
    elseif is_assign(stm) then
      local assigns = assigns_by_name(stm)
      for k, v in pairs(assigns) do
        locals[k] = v
      end
    end
  end
  local out = { }
  local last = tree[#tree]
  if is_table(last) then
    out.exports = { }
    local _list_0 = last[2]
    for _index_0 = 1, #_list_0 do
      local _continue_0 = false
      repeat
        local _des_0 = _list_0[_index_0]
        local key, value
        key, value = _des_0[1], _des_0[2]
        if not (is_key_literal(key)) then
          _continue_0 = true
          break
        end
        local export_name = key[2]
        if not (is_ref(value)) then
          _continue_0 = true
          break
        end
        local local_name = value[2]
        do
          local export_value = locals[local_name]
          if export_value then
            out.exports[export_name] = format_stm(export_value, {
              name = export_name,
              line_number = export_value[-1] and pos_to_line(code, export_value[-1])
            })
          end
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
  else
    error("not yet")
  end
  return out
end
return {
  parse_exports = parse_exports
}
