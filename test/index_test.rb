require "minitest"
require "minitest/spec"
require "minitest/autorun"

require_relative "../lib/index"

describe Index do
  attr_reader :text

  def setup
    @text = "mary had a little lamb\nlittle lamb little lamb\nits fleece was white or whatever"
  end
  it "indexes text" do
    index = Index.new
    assert_equal 3, index.index_text(text) #returns # of lines indexed
  end

  it "links occurrences when indexing" do
    index = Index.new
    index.index_text(text, "mary")
    o = index.index["mary"].first
    assert_equal Occurrence, o.class
    assert_equal "mary", o.word
    assert_equal "had", o.neighbor.word
  end

  it "takes optional filename with text" do
    index = Index.new
    assert_equal 3, index.index_text(text, "mary") #returns # of lines indexed
  end

  it "can query on indexed text" do
    index = Index.new
    index.index_text(text, "mary") #returns # of lines indexed
    assert_equal ["mary:0:0"], index.query("mary")
  end

  it "tracks occurrences as objects" do
    index = Index.new
    index.index_text(text, "mary")
    assert_equal Occurrence, index.index["mary"].first.class
  end

  it "clears the index" do
    index = Index.new
    index.index_text(text, "mary")
    assert index.index.keys.any?
    index.clear
    refute index.index.keys.any?
  end

  it "finds multiword query via occurrences" do
    index = Index.new
    index.index_text(text, "mary")
    assert_equal ["mary:2:1"], index.query("fleece was white")
  end
end

describe Occurrence do
  it "finds its children" do
    o1 = Occurrence.new("hi", "file:0:0")
    o2 = Occurrence.new("there", "file:0:1")
    o1.neighbor = o2
    assert_equal [o2], o1.children(1)
  end

  it "defaults children count to 0" do
    o1 = Occurrence.new("hi", "file:0:0")
    o2 = Occurrence.new("there", "file:0:1")
    o1.neighbor = o2
    assert_equal [], o1.children
  end

  it "finds multiple at a time" do
    o1 = Occurrence.new("hi", "file:0:0")
    o2 = Occurrence.new("there", "file:0:1")
    o3 = Occurrence.new("pizza", "file:0:1")
    o1.neighbor = o2
    o2.neighbor = o3
    assert_equal [o2, o3], o1.children(2)
  end
end
