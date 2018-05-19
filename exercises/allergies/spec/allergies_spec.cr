require "spec"
require "../src/*"

describe "Allergies" do
  it "no allergies means not allergic" do
    allergies = Allergies.new(0)
    allergies.allergic_to?("peanuts").should be_false
    allergies.allergic_to?("cats").should be_false
    allergies.allergic_to?("strawberries").should be_false
  end

  pending "is allergic to eggs" do
    allergies = Allergies.new(1)
    allergies.allergic_to?("eggs").should be_true
  end

  pending "allergic to eggs in addition to other stuff" do
    allergies = Allergies.new(5)
    allergies.allergic_to?("eggs").should be_true
    allergies.allergic_to?("shellfish").should be_true
    allergies.allergic_to?("strawberries").should be_false
  end

  pending "no allergies at all" do
    Allergies.new(0).list.should eq([] of String)
  end

  pending "allergic to just eggs" do
    Allergies.new(1).list.should eq(["eggs"])
  end

  pending "allergic to just peanuts" do
    Allergies.new(2).list.should eq(["peanuts"])
  end

  pending "allergic to just strawberries" do
    Allergies.new(8).list.should eq(["strawberries"])
  end

  pending "allergic to eggs and peanuts" do
    Allergies.new(3).list.should eq(["eggs", "peanuts"])
  end

  pending "allergic to more than eggs but not peanuts" do
    Allergies.new(5).list.should eq(["eggs", "shellfish"])
  end

  pending "allergic to lots of stuff" do
    Allergies.new(248).list.should eq(["strawberries", "tomatoes", "chocolate", "pollen", "cats"])
  end

  pending "allergic to everything" do
    Allergies.new(255).list.should eq(["eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"])
  end

  pending "ignore non allergen score parts" do
    Allergies.new(509).list.should eq(["eggs", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"])
  end
end
