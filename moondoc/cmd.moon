
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
