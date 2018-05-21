require "spec"
require "../src/*"

describe "Atbash" do
  describe "#encode" do
    it "encodes yes" do
      Atbash.encode("yes").should eq "bvh"
    end

    pending "encodes no" do
      Atbash.encode("no").should eq "ml"
    end

    pending "encodes OMG" do
      Atbash.encode("OMG").should eq "lnt"
    end

    pending "encodes spaces" do
      Atbash.encode("O M G").should eq "lnt"
    end

    pending "encodes mindblowingly" do
      Atbash.encode("mindblowingly").should eq "nrmwy oldrm tob"
    end

    pending "encodes numbers" do
      Atbash.encode("Testing,1 2 3, testing.").should eq "gvhgr mt123 gvhgr mt"
    end

    pending "encodes deep thought" do
      Atbash.encode("Truth is fiction.").should eq "gifgs rhurx grlm"
    end

    pending "encodes all the letters" do
      Atbash.encode("The quick brown fox jumps over the lazy dog.").should eq "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt"
    end
  end

  describe "#decode" do
    pending "decodes exercism" do
      Atbash.decode("vcvix rhn").should eq "exercism"
    end

    pending "decodes a sentence" do
      Atbash.decode("zmlyh gzxov rhlug vmzhg vkkrm thglm v").should eq "anobstacleisoftenasteppingstone"
    end

    pending "decodes numbers" do
      Atbash.decode("gvhgr mt123 gvhgr mt").should eq "testing123testing"
    end

    pending "decodes all the letters" do
      Atbash.decode("gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt").should eq "thequickbrownfoxjumpsoverthelazydog"
    end
  end
end
