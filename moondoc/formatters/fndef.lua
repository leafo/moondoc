local format_stm
format_stm = require("moondoc.format").format_stm
local types
types = require("tableshape").types
local is_method = types.shape({
  "fndef",
  types.table,
  types.table,
  "fat"
}, {
  open = true
})
return function(node)
  local arguments = { }
  local raw_args = node[2]
  for _index_0 = 1, #raw_args do
    local _des_0 = raw_args[_index_0]
    local name, default
    name, default = _des_0[1], _des_0[2]
    if default then
      default = format_stm(default)
    end
    table.insert(arguments, {
      name = name,
      default = default
    })
  end
  return {
    type = is_method(node) and "method" or "function",
    arguments = arguments
  }
end
