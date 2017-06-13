package = "moondoc"
version = "dev-1"

source = {
  url = "git://github.com/leafo/moondoc.git",
  branch = "master",
}

description = {
  summary = "Documentation page generator for MoonScript",
  license = "MIT",
  maintainer = "Leaf Corcoran <leafot@gmail.com>",
}

dependencies = {
  "lua ~> 5.1",
  "moonscript",
  "loadkit",
  "sitegen",
}

build = {
  type = "builtin",
  modules = {
    ["moondoc"] = "moondoc/init.lua",
    ["moondoc.cmd"] = "moondoc/cmd.lua",
    ["moondoc.format"] = "moondoc/format.lua",
    ["moondoc.formatters.class"] = "moondoc/formatters/class.lua",
    ["moondoc.formatters.fndef"] = "moondoc/formatters/fndef.lua",
    ["moondoc.formatters.number"] = "moondoc/formatters/number.lua",
    ["moondoc.formatters.string"] = "moondoc/formatters/string.lua",
    ["moondoc.formatters.table"] = "moondoc/formatters/table.lua",
  },
  install = {
    bin = { "bin/moondoc" }
  }
}
