# Stolen shamelessly from the ruby solution
# https://github.com/exercism/ruby/blob/76107ac6/exercises/beer-song/.meta/solutions/beer_song.rb
module BeerSong
  extend self

  def lyrics(upper_bound, count)
    upper_bound.downto(upper_bound - count + 1).map { |i| verse(i) }.join("\n\n")
  end

  def verse(number)
    case number
    when 0
      "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall."
    when 1
      "#{number} bottle of beer on the wall, #{number} bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall."
    when 2
      "#{number} bottles of beer on the wall, #{number} bottles of beer.\nTake one down and pass it around, #{number - 1} bottle of beer on the wall."
    else
      "#{number} bottles of beer on the wall, #{number} bottles of beer.\nTake one down and pass it around, #{number - 1} bottles of beer on the wall."
    end
  end
end
