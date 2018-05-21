require "../generator"

class BeerSongTestCase
  class Input
    JSON.mapping({
      startBottles: Int32,
      takeDown: Int32,
    })
  end

  include TestDSL
  include Exercise::TestCase(Input, Array(String))

  def describe_group
    group.try &.visible = false
    group.try &.group.try &.description || ""
  end

  def test_input
    if describe_group == "verse"
      input.startBottles
    else
      "#{input.startBottles}, #{input.takeDown}"
    end
  end

  def test_output
    "<<-BEER\n    #{expected.join("\n    ")}\n    BEER"
  end

  _it "should #{property} #{description}" do
    "BeerSong.#{describe_group}(#{test_input}).should eq #{test_output}"
  end
end

Generator.register :BeerSong
