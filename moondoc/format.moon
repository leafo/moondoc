
format_stm = (node, more_props) ->
  return unless node
  node_type = node[1]
  assert type(node_type) == "string",
    "invalid node type: #{type node_type}"

  local formatter
  pcall ->
    formatter = require "moondoc.formatters.#{node_type}"

  return unless formatter
  out = formatter node

  if out
    if more_props
      for k,v in pairs more_props
        out[k] = v

    out

{:format_stm}

