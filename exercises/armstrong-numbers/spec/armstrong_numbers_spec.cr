require "spec"
require "../src/*"

describe "ArmstrongNumbers" do
  it "single digit numbers are armstrong numbers" do
    5.armstrong?.should be_true
  end

  pending "there are no 2 digit armstrong numbers" do
    10.armstrong?.should be_false
  end

  pending "three digit number that is an armstrong number" do
    153.armstrong?.should be_true
  end

  pending "three digit number that is not an armstrong number" do
    100.armstrong?.should be_false
  end

  pending "four digit number that is an armstrong number" do
    9474.armstrong?.should be_true
  end

  pending "four digit number that is not an armstrong number" do
    9475.armstrong?.should be_false
  end

  pending "seven digit number that is an armstrong number" do
    9926315.armstrong?.should be_true
  end

  pending "seven digit number that is not an armstrong number" do
    9926314.armstrong?.should be_false
  end
end
