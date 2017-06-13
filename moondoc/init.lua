local parse = require("moonscript.parse")
local loadkit = require("loadkit")
local pos_to_line
pos_to_line = require("moonscript.util").pos_to_line
local types
types = require("tableshape").types
local format_stm
format_stm = require("moondoc.format").format_stm
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
local Buffer
do
  local _class_0
  local _base_0 = {
    pos_to_line = function(self, pos)
      if not (pos) then
        return nil
      end
      return pos_to_line(self.buffer, pos)
    end,
    get_proceeding_comment = function(self, pos) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, buffer)
      self.buffer = buffer
    end,
    __base = _base_0,
    __name = "Buffer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Buffer = _class_0
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
local parse_exports
parse_exports = function(code, opts)
  if opts == nil then
    opts = { }
  end
  local buffer = Buffer(code)
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
    out.type = "table"
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
            local formatted = format_stm(export_value, {
              name = export_name,
              line_number = buffer:pos_to_line(export_value[-1])
            })
            if not (formatted) then
              _continue_0 = true
              break
            end
            table.insert(out.exports, formatted)
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
local filename_for_module
filename_for_module = function(module_name)
  local loader = loadkit.make_loader("moon", nil, "./?.lua")
  return assert(loader(module_name))
end
local parse_module
parse_module = function(module_name, fname)
  fname = fname or filename_for_module(module_name)
  local f = assert(io.open(fname))
  local file = f:read("*a")
  f:close()
  local out = parse_exports(file)
  out.name = module_name
  return out
end
local shell_escape
shell_escape = function(str)
  return str:gsub("'", "''")
end
local scan_for_modules
scan_for_modules = function(dir)
  if dir == nil then
    dir = "."
  end
  local f = assert(io.popen("find '" .. tostring(shell_escape(dir)) .. "' -type f -iname '*.moon' -print0"))
  local files = f:read("*a")
  local out
  do
    local _accum_0 = { }
    local _len_0 = 1
    for file in files:gmatch("[^%z]+") do
      local module_name = file:gsub("^%./", ""):gsub("%.moon$", ""):gsub("/", ".")
      if module_name:match("%.init$") then
        module_name = module_name:sub(1, -(#".init" + 1))
      end
      local _value_0 = {
        file,
        module_name
      }
      _accum_0[_len_0] = _value_0
      _len_0 = _len_0 + 1
    end
    out = _accum_0
  end
  table.sort(out, function(a, b)
    return a[2] < b[2]
  end)
  return out
end
return {
  parse_exports = parse_exports,
  parse_module = parse_module,
  scan_for_modules = scan_for_modules
}
