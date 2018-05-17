require "../generator"

class RunLengthEncodingTestCase
  class Input
    JSON.mapping({string: String})
  end

  include Exercise::TestCase(Input, String)

  def test_workload
    if test_method == "consistency"
      "#{test_class}.decode(#{test_class}.encode(\"#{input.string}\")).should eq(\"#{expected}\")"
    else
      "#{test_class}.#{test_method}(\"#{input.string}\").should eq(\"#{expected}\")"
    end
  end

  def test_description
    test_method == "consistency" ? description : "#{test_method} #{description}"
  end
end

Generator.register :RunLengthEncoding
