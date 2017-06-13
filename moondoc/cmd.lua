local parse_flags
parse_flags = function(input)
  local flags = { }
  local filtered
  do
    local _accum_0 = { }
    local _len_0 = 1
    for _index_0 = 1, #input do
      local _continue_0 = false
      repeat
        local arg = input[_index_0]
        do
          local flag = arg:match("^%-%-?(.+)$")
          if flag then
            local k, v = flag:match("(.-)=(.*)")
            if k then
              flags[k] = v
            else
              flags[flag] = true
            end
            _continue_0 = true
            break
          end
        end
        local _value_0 = arg
        _accum_0[_len_0] = _value_0
        _len_0 = _len_0 + 1
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
    filtered = _accum_0
  end
  return flags, filtered
end
local actions = {
  scan_modules = function(args, flags)
    local scan_for_modules
    scan_for_modules = require("moondoc").scan_for_modules
    local path = unpack(args) or "."
    local _list_0 = scan_for_modules(path)
    for _index_0 = 1, #_list_0 do
      local _des_0 = _list_0[_index_0]
      local fname, mod
      fname, mod = _des_0[1], _des_0[2]
      print(mod)
    end
  end,
  help = function(self) end
}
local run
run = function(...)
  local flags, args = parse_flags({
    ...
  })
  local action_name = args[1]
  if not (action_name) then
    action_name = "help"
  end
  table.remove(args, 1)
  assert(actions[action_name], "unknown command: " .. tostring(action_name))
  return actions[action_name](args, flags)
end
return {
  run = run
}
