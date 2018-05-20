require "spec"
require "../src/*"

describe "Alphametics" do
  it "puzzle with three letters" do
    Alphametics.solve("I + BB == ILL").should eq({"I" => 1, "B" => 9, "L" => 0})
  end

  pending "solution must have unique value for each letter" do
    Alphametics.solve("A == B").should eq({} of String => Int32)
  end

  pending "leading zero solution is invalid" do
    Alphametics.solve("ACA + DD == BD").should eq({} of String => Int32)
  end

  pending "puzzle with four letters" do
    Alphametics.solve("AS + A == MOM").should eq({"A" => 9, "S" => 2, "M" => 1, "O" => 0})
  end

  pending "puzzle with six letters" do
    Alphametics.solve("NO + NO + TOO == LATE").should eq({"N" => 7, "O" => 4, "T" => 9, "L" => 1, "A" => 0, "E" => 2})
  end

  pending "puzzle with seven letters" do
    Alphametics.solve("HE + SEES + THE == LIGHT").should eq({"E" => 4, "G" => 2, "H" => 5, "I" => 0, "L" => 1, "S" => 9, "T" => 7})
  end

  pending "puzzle with eight letters" do
    Alphametics.solve("SEND + MORE == MONEY").should eq({"S" => 9, "E" => 5, "N" => 6, "D" => 7, "M" => 1, "O" => 0, "R" => 8, "Y" => 2})
  end

  pending "puzzle with ten letters" do
    Alphametics.solve("AND + A + STRONG + OFFENSE + AS + A + GOOD == DEFENSE").should eq({"A" => 5, "D" => 3, "E" => 4, "F" => 7, "G" => 8, "N" => 0, "O" => 2, "R" => 1, "S" => 6, "T" => 9})
  end

  pending "puzzle with ten letters and 199 addends" do
    Alphametics.solve("THIS + A + FIRE + THEREFORE + FOR + ALL + HISTORIES + I + TELL + A + TALE + THAT + FALSIFIES + ITS + TITLE + TIS + A + LIE + THE + TALE + OF + THE + LAST + FIRE + HORSES + LATE + AFTER + THE + FIRST + FATHERS + FORESEE + THE + HORRORS + THE + LAST + FREE + TROLL + TERRIFIES + THE + HORSES + OF + FIRE + THE + TROLL + RESTS + AT + THE + HOLE + OF + LOSSES + IT + IS + THERE + THAT + SHE + STORES + ROLES + OF + LEATHERS + AFTER + SHE + SATISFIES + HER + HATE + OFF + THOSE + FEARS + A + TASTE + RISES + AS + SHE + HEARS + THE + LEAST + FAR + HORSE + THOSE + FAST + HORSES + THAT + FIRST + HEAR + THE + TROLL + FLEE + OFF + TO + THE + FOREST + THE + HORSES + THAT + ALERTS + RAISE + THE + STARES + OF + THE + OTHERS + AS + THE + TROLL + ASSAILS + AT + THE + TOTAL + SHIFT + HER + TEETH + TEAR + HOOF + OFF + TORSO + AS + THE + LAST + HORSE + FORFEITS + ITS + LIFE + THE + FIRST + FATHERS + HEAR + OF + THE + HORRORS + THEIR + FEARS + THAT + THE + FIRES + FOR + THEIR + FEASTS + ARREST + AS + THE + FIRST + FATHERS + RESETTLE + THE + LAST + OF + THE + FIRE + HORSES + THE + LAST + TROLL + HARASSES + THE + FOREST + HEART + FREE + AT + LAST + OF + THE + LAST + TROLL + ALL + OFFER + THEIR + FIRE + HEAT + TO + THE + ASSISTERS + FAR + OFF + THE + TROLL + FASTS + ITS + LIFE + SHORTER + AS + STARS + RISE + THE + HORSES + REST + SAFE + AFTER + ALL + SHARE + HOT + FISH + AS + THEIR + AFFILIATES + TAILOR + A + ROOFS + FOR + THEIR + SAFE == FORTRESSES").should eq({"A" => 1, "E" => 0, "F" => 5, "H" => 8, "I" => 7, "L" => 2, "O" => 6, "R" => 3, "S" => 4, "T" => 9})
  end
end
