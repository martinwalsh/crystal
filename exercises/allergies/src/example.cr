# Shamelessly stolen from the ruby solution here:
# https://github.com/exercism/ruby/blob/3e635ba4/exercises/allergies/.meta/solutions/allergies.rb
class Allergies
  ALLERGENS = %w(eggs peanuts shellfish strawberries tomatoes chocolate pollen cats)

  def initialize(@score : Int32)
  end

  def list
    ALLERGENS.select do |item|
      allergic_to?(item)
    end
  end

  def allergic_to?(item)
    index = ALLERGENS.index(item).as(Int32)
    @score & (2 ** index) > 0
  end
end
