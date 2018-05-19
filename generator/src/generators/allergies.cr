require "../generator"

class AllergiesTestCase
  class Input
    JSON.mapping(score: Int32)
  end

  class Substance
    JSON.mapping({
      substance: String,
      result: Bool,
    })
  end

  include TestDSL
  include Exercise::TestCase(Input, Array(String) | Array(Substance))

  _it description do
    if property == "allergicTo"
      workload = ["allergies = Allergies.new(#{input.score})"]
      expected.as(Array(Substance)).map do |e|
        workload << "allergies.allergic_to?(\"#{e.substance}\").should be_#{e.result}"
      end
      workload.join("\n  ")
    else
      "Allergies.new(#{input.score}).list.should eq(#{expected.empty? ? "[] of String" : expected })"
    end
  end
end

Generator.register :Allergies
