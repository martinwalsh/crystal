class TestTestCase
  include Exercise::TestCase(Int32, Int32)

  def test_description
    "should do #{description}"
  end

  def test_workload
    if should_raise?
      <<-EOF
      expect_raises(ArgumentError) do
          Test.yup(#{input}).should eq(#{expected})
        end
      EOF
    else
      "Test.yup(#{input}).should eq(#{expected})"
    end
  end

  def should_raise?
    expected == 0
  end
end

class TestTestCaseWithBonus
  include Exercise::TestCase(Int32, Int32)

  def test_description
    description
  end

  def test_workload
    "whatever"
  end

  test_class "MyTestClass"

  spec_helper
  bonus_prefix on: /.+/
end

class TestTestCaseWithDescribeContextual
  include Exercise::TestCase(Int32, Int32)

  def test_description
    description
  end

  def test_workload
    "whatever"
  end

  describe_contextual ".woot"
end

class TestTestCaseWithDescribeGroup
  include Exercise::TestCase(Int32, Int32)

  def test_description
    description
  end

  def test_workload
    "whatever"
  end

  describe_contextual ".wahoo"
  describe_group "##{description}"
end
