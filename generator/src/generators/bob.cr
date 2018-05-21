require "../generator"

class BobTestCase
  class Input
    JSON.mapping({ heyBob: String })
  end

  include TestDSL
  include Exercise::TestCase(Input, String)

  def escaped
    input.heyBob.inspect
  end

  describe_contextual "#hey"

  _it "responds to #{description}" do
    "Bob.hey(#{escaped}).should eq #{expected.inspect}"
  end
end

Generator.register :Bob
