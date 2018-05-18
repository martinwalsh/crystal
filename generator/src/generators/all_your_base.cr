require "../generator"

class AllYourBaseTestCase
  class Input
    JSON.mapping({
      inputBase: Int32,
      digits: Array(Int32),
      outputBase: Int32,
    })
  end

  include TestDSL
  include Exercise::TestCase(Input, Array(Int32) | Hash(String, String))

  def digits
    input.digits.empty? ? "[] of Int32" : input.digits
  end

  _it description do
    "AllYourBase.rebase(#{input.inputBase}, #{digits}, #{input.outputBase}).should eq(#{expected})"
  end

  _expect_raises(ArgumentError, when: expected.responds_to? :has_key?) do
    "AllYourBase.rebase(#{input.inputBase}, #{digits}, #{input.outputBase})"
  end
end

Generator.register :AllYourBase
