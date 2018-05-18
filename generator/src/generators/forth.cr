require "../generator"

class ForthTestCase
  class Input
    JSON.mapping(instructions: Array(String))
  end

  include TestDSL
  include Exercise::TestCase(Input, Array(Int32)?)

  def output
    expected.try &.empty? ? "[] of Int32" : expected
  end

  _it description do
    "Forth.evaluate(\"#{input.instructions.join}\").should eq(#{output})"
  end

  _expect_raises(Exception, when: expected.nil?) do
    "Forth.evaluate(\"#{input.instructions.join}\")"
  end
end

Generator.register :Forth
