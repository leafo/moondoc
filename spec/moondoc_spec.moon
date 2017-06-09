

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
          arguments: {}
          line_number: 1
        }
      }

    }, out

  it "parses function with arguments", ->
    out = parse_exports [[
cool = (a,b,c=5)->
{out: cool}
]]
    assert.same {
      exports: {
        {
          type: "function"
          name: "out"
          line_number: 1
          arguments: {
            {name: "a"}
            {name: "b"}
            {name: "c", default: {
              type: "number"
              value: "5"
            }}
          }
        }
      }
    }, out

