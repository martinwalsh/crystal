require "spec"
require "../src/exercise"

require "./fixtures/test_dsl_test_case"

describe TestDSL do
  it "renders a valid unit test" do
    spec = Exercise::Spec(TestDSLTestCase).from_canonical(File.read("#{__DIR__}/fixtures/data/valid.json"))
    spec.to_s.should match(/should do whatevs.*Test\.yup\(1\)\.should eq\(2\)/m)
  end

  it "renders a valid error case" do
    spec = Exercise::Spec(TestDSLTestCase).from_canonical(File.read("#{__DIR__}/fixtures/data/raises-error.json"))
    spec.to_s.should match(/should do whatevs.*expect_raises\(ArgumentError\) do.*Test\.yup\(1\)/m)
  end

  it "renders a valid error case using when" do
    spec = Exercise::Spec(TestDSLTestCaseWithWhen).from_canonical(File.read("#{__DIR__}/fixtures/data/raises-error.json"))
    spec.to_s.should match(/should do whatevs.*expect_raises\(ArgumentError\) do.*Test\.yup\(1\)/m)
  end

  it "does not render a expect_raises *when* it shouldn't" do
    spec = Exercise::Spec(TestDSLTestCaseWithWhen).from_canonical(File.read("#{__DIR__}/fixtures/data/valid.json"))
    spec.to_s.should match(/should do whatevs.*Test\.yup\(1\)\.should eq\(2\)/m)
  end

  it "renders a valid unit test using with_message" do
    spec = Exercise::Spec(TestDSLTestCaseWithMessage).from_canonical(File.read("#{__DIR__}/fixtures/data/valid.json"))
    spec.to_s.should match(/should do whatevs.*Test\.yup\(1\)\.should eq\(2\)/m)
  end

  it "renders a valid error case using with_message" do
    spec = Exercise::Spec(TestDSLTestCaseWithMessage).from_canonical(File.read("#{__DIR__}/fixtures/data/raises-error.json"))
    spec.to_s.should match(/expect_raises\(ArgumentError, \/\(\?-imsx:\.\+\)/)
  end
end
