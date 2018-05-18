require "../generator"

class TriangleTestCase
  class Input
    JSON.mapping(sides: Array(Int32) | Array(Float64))
  end

  include TestDSL
  include Exercise::TestCase(Input, Bool)

  def sides
    input.sides.map_with_index do |n, i|
      n.to_i == input.sides[i] ? n.to_i : n.to_f
    end
  end

  _it description do
    "Triangle.new(#{sides}).#{property}?.should eq(#{expected})"
  end
end

Generator.register :Triangle
