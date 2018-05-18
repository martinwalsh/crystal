require "../generator"

class DifferenceOfSquaresTestCase
  class Input
    JSON.mapping(number: Int32)
  end

  include TestDSL
  include Exercise::TestCase(Input, Int32)

  _it "calculates #{description} is #{expected}" do
    "Squares.#{test_method}(#{input.number}).should eq(#{expected})"
  end
end

Generator.register :DifferenceOfSquares
