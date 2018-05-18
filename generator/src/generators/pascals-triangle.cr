require "../generator"

class PascalsTriangleTestCase
  class Input
    JSON.mapping(count: Int32)
  end

  include TestDSL
  include Exercise::TestCase(Input, Array(Array(Int32)) | Int32)

  def test_name
    if should_raise?
      "will raise an Argument error for #{description}"
    else
      "will return the first #{input.count} row(s)"
    end
  end

  def output
    expected.as(Array).empty? ? "[] of Int32" : expected
  end

  _it test_name do
    "PascalsTriangle.rows(#{input.count}).should eq(#{output})"
  end

  _expect_raises(ArgumentError, when: expected == -1) do
    "PascalsTriangle.rows(#{input.count})"
  end
end

Generator.register :PascalsTriangle
