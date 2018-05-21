require "../generator"

class AnagramTestCase
  class Input
    JSON.mapping({
      subject: String,
      candidates: Array(String),
    })
  end

  include TestDSL
  include Exercise::TestCase(Input, Array(String))

  describe_contextual ".find"

  def output
    expected.empty? ? "[] of String" : expected
  end

  _it description do
    "Anagram.find(#{input.subject.inspect}, #{input.candidates}).should eq #{output}"
  end
end

Generator.register :Anagram
