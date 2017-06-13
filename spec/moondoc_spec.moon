
import types from require "tableshape"

describe "parse_expresion", ->
  import parse_expresion from require "moondoc"

  it "parses function", ->
    assert.same {
      type: "function"
      arguments: {
        {name: "a"}
        {name: "b"}
      }
    }, parse_expresion [[(a,b) ->]]

  it "parses function with argument defaults", ->
    assert.same {
      type: "function"
      type: "function"
      arguments: {
        {name: "a"}
        {name: "b"}
        {name: "c", default: {
          type: "number"
          value: "5"
        }}
      }
    }, parse_expresion [[(a,b,c=5) ->]]

describe "parse_module", ->
  import parse_module, parse_module_by_name from require "moondoc"

  it "loads module from path", ->
    out = parse_module_by_name "moondoc.init"
    s = types.shape {
      name: "moondoc.init"
    }, open: true
    assert s out

  describe "module types", ->
    it "loads table module", ->
      out = parse_module [[{}]]
      assert.same {
        exports: {}
        type: "table"
      }, out

    it "loads class module", -> pending "todo"
    it "loads value module", -> pending "todo"
    it "loads expression module", -> pending "todo"

  it "parses exports with table and function", ->
    out = parse_module [[
f = ->
class Something
{:Something, :f}
]]
    
    assert.same {
      type: "table"
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
    out = parse_module [[
cool = (a,b,c=5)->
{out: cool}
]]
    assert.same {
      type: "table"
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

