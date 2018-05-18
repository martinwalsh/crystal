class TestDSLTestCase
  include TestDSL
  include Exercise::TestCase(Int32, Int32)

  _it "should do #{description}" do
    "Test.yup(#{input}).should eq(#{expected})"
  end

  _expect_raises(ArgumentError) do
    "Test.yup(#{input})"
  end

  def should_raise?
    expected == 0
  end
end

class TestDSLTestCaseWithWhen
  include TestDSL
  include Exercise::TestCase(Int32, Int32)

  _it "should do #{description}" do
    "Test.yup(#{input}).should eq(#{expected})"
  end

  _expect_raises(ArgumentError, when: expected == 0) do
    "Test.yup(#{input})"
  end
end

class TestDSLTestCaseWithMessage
  include TestDSL
  include Exercise::TestCase(Int32, Int32)

  _it "should do #{description}" do
    "Test.yup(#{input}).should eq(#{expected})"
  end

  _expect_raises(ArgumentError, with_message: /.+/) do
    "Test.yup(#{input})"
  end

  def should_raise?
    expected == 0
  end
end
