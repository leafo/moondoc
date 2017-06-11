local types
types = require("tableshape").types
local is_empty = types.shape({
  "table",
  types.shape({ })
}, {
  open = true
})
return function(node)
  return {
    type = "table"
  }
end
