
parse_flags = (input) ->
  flags = {}

  filtered = for arg in *input
    if flag = arg\match "^%-%-?(.+)$"
      k,v = flag\match "(.-)=(.*)"
      if k
        flags[k] = v
      else
        flags[flag] = true
      continue
    arg

  flags, filtered

actions = {
  scan_modules: (args, flags) ->
    import scan_for_modules from require "moondoc"
    path = unpack(args) or "."
    for {fname, mod} in *scan_for_modules path
      print mod

  module_exports: (args, flags) ->
    import parse_module_by_name from require "moondoc"
    mod_name = unpack(args) or error "Missing module name"
    data = parse_module_by_name mod_name
    require("moon").p data

  help: =>

}

run = (...) ->
  flags, args = parse_flags {...}
  action_name = args[1]
  action_name = "help" unless action_name

  table.remove args, 1

  assert actions[action_name], "unknown command: #{action_name}"
  actions[action_name] args, flags

{:run}
