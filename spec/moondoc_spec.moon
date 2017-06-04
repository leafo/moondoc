

describe "parse_exports", ->
  import parse_exports from require "moondoc"

  it "parses exports with table and function", ->
    out = parse_exports [[
f = ->
class Something
{:Something, :f}
]]
    
    assert.same {
      exports: {
        {
          type: "class"
          name: "Something"
          methods: {}
          class_methods: {}
          line_number: 2
        }

        {
          type: "function"
          name: "f"
          line_number: 1
        }
      }

    }, out



