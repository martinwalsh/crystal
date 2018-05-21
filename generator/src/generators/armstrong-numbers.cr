require "../generator"

class ArmstrongNumbersTestCase
  include Exercise::TestCase(Hash(String, Int32), Bool)
  include TestDSL

  _it description.downcase do
    "#{input["number"]}.armstrong?.should be_#{expected}"
  end
end

Generator.register :ArmstrongNumbers
