require "../generator"

class AtbashCipherTestCase
  include TestDSL
  include Exercise::TestCase(Hash(String, String), String)

  describe_group "##{description}"
  test_class "Atbash"

  _it description.gsub(/(encode|decode)/, "\\1s") do
    "#{test_class}.#{test_method}(#{input["phrase"].inspect}).should eq #{expected.inspect}"
  end
end

Generator.register :AtbashCipher
