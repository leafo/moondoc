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
  },
  install = {
    bin = { "bin/moondoc.moon" }
  }
}
