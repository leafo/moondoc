local format_stm
format_stm = require("moondoc.format").format_stm
local types
types = require("tableshape").types
local is_props = types.shape({
  "props"
}, {
  open = true
})
local is_key_literal = types.shape({
  "key_literal",
  types.string
}, {
  open = true
})
local is_self = types.shape({
  "self",
  types.string
}, {
  open = true
})
local is_function = types.shape({
  "fndef"
}, {
  open = true
})
local is_method = types.shape({
  "props",
  types.shape({
    is_key_literal,
    is_function
  })
})
local is_class_method = types.shape({
  "props",
  types.shape({
    is_self,
    is_function
  })
})
return function(node)
  local contents = node[4]
  local methods = { }
  local class_methods = { }
  for _index_0 = 1, #contents do
    local p = contents[_index_0]
    local add_item
    add_item = function(list, p)
      local key, value
      do
        local _obj_0 = p[2]
        key, value = _obj_0[1], _obj_0[2]
      end
      local property_name = key[2]
      local formatted = format_stm(value, {
        name = property_name
      })
      return table.insert(list, formatted)
    end
    if is_method(p) then
      add_item(methods, p)
    end
    if is_class_method(p) then
      add_item(class_methods, p)
    end
  end
  return {
    type = "class",
    methods = methods,
    class_methods = class_methods
  }
end
