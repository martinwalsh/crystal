require "spec"
require "../src/*"

describe "Bob" do
  it "responds to stating something" do
    Bob.response("Tom-ay-to, tom-aaaah-to.").should eq("Whatever.")
  end

  it "responds to shouting" do
    Bob.response("WATCH OUT!").should eq("Whoa, chill out!")
  end

  it "responds to shouting gibberish" do
    Bob.response("FCECDFCAAB").should eq("Whoa, chill out!")
  end

  it "responds to asking a question" do
    Bob.response("Does this cryogenic chamber make me look fat?").should eq("Sure.")
  end

  it "responds to asking a numeric question" do
    Bob.response("You are, what, like 15?").should eq("Sure.")
  end

  it "responds to asking gibberish" do
    Bob.response("fffbbcbeab?").should eq("Sure.")
  end

  it "responds to talking forcefully" do
    Bob.response("Let's go make out behind the gym!").should eq("Whatever.")
  end

  it "responds to using acronyms in regular speech" do
    Bob.response("It's OK if you don't want to go to the DMV.").should eq("Whatever.")
  end

  it "responds to forceful question" do
    Bob.response("WHAT THE HELL WERE YOU THINKING?").should eq("Calm down, I know what I'm doing!")
  end

  it "responds to shouting numbers" do
    Bob.response("1, 2, 3 GO!").should eq("Whoa, chill out!")
  end

  it "responds to only numbers" do
    Bob.response("1, 2, 3").should eq("Whatever.")
  end

  it "responds to question with only numbers" do
    Bob.response("4?").should eq("Sure.")
  end

  it "responds to shouting with special characters" do
    Bob.response("ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!").should eq("Whoa, chill out!")
  end

  it "responds to shouting with no exclamation mark" do
    Bob.response("I HATE YOU").should eq("Whoa, chill out!")
  end

  it "responds to statement containing question mark" do
    Bob.response("Ending with ? means a question.").should eq("Whatever.")
  end

  it "responds to non-letters with question" do
    Bob.response(":) ?").should eq("Sure.")
  end

  it "responds to prattling on" do
    Bob.response("Wait! Hang on. Are you going to be OK?").should eq("Sure.")
  end

  it "responds to silence" do
    Bob.response("").should eq("Fine. Be that way!")
  end

  it "responds to prolonged silence" do
    Bob.response("          ").should eq("Fine. Be that way!")
  end

  it "responds to alternate silence" do
    Bob.response("\t\t\t\t\t\t\t\t\t\t").should eq("Fine. Be that way!")
  end

  it "responds to multiple line question" do
    Bob.response("\nDoes this cryogenic chamber make me look fat?\nno").should eq("Whatever.")
  end

  it "responds to starting with whitespace" do
    Bob.response("         hmmmmmmm...").should eq("Whatever.")
  end

  it "responds to ending with whitespace" do
    Bob.response("Okay if like my  spacebar  quite a bit?   ").should eq("Sure.")
  end

  it "responds to other whitespace" do
    Bob.response("\n\r \t").should eq("Fine. Be that way!")
  end

  it "responds to non-question ending with whitespace" do
    Bob.response("This is a statement ending with whitespace      ").should eq("Whatever.")
  end
end
