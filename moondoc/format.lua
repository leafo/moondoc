local format_stm
format_stm = function(node, more_props)
  if not (node) then
    return 
  end
  local node_type = node[1]
  assert(type(node_type) == "string", "invalid node type: " .. tostring(type(node_type)))
  local formatter
  formatter = require("moondoc.formatters." .. tostring(node_type))
  if not (formatter) then
    return 
  end
  local out = formatter(node)
  if out then
    if more_props then
      for k, v in pairs(more_props) do
        out[k] = v
      end
    end
    return out
  end
end
return {
  format_stm = format_stm
}
