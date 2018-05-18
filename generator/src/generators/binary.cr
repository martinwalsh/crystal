require "../generator"

class BinaryTestCase
  class Input
    JSON.mapping(binary: String)
  end

  include TestDSL
  include Exercise::TestCase(Input, Int32?)

  _it description do
    "Binary.to_decimal(\"#{input.binary}\").should eq(#{expected})"
  end

  _expect_raises(ArgumentError, when: expected.nil?) do
    "Binary.to_decimal(\"#{input.binary}\")"
  end
end

Generator.register :Binary
