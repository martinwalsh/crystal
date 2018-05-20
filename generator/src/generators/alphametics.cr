require "../generator"

class AlphameticsTestCase
  include TestDSL
  include Exercise::TestCase(Hash(String, String), Hash(String, Int32)?)

  def output
    expected ? expected : "{} of String => Int32"
  end

  _it description do
    "Alphametics.solve(\"#{input["puzzle"]}\").should eq(#{output})"
  end
end

Generator.register :Alphametics
