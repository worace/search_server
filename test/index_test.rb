require "minitest"
require "minitest/spec"
require "minitest/autorun"

require_relative "../lib/index"

describe Index do
  it "exists" do
    assert Index
  end

  it "indexes text" do
    text = "mary had a little lamb\nlittle lamb little lamb\nits fleece was white or whatever"
    index = Index.new
    assert_equal 3, index.index_text(text) #returns # of lines indexed
  end

  it "takes optional filename with text" do
    text = "mary had a little lamb\nlittle lamb little lamb\nits fleece was white or whatever"
    index = Index.new
    assert_equal 3, index.index_text(text, "mary") #returns # of lines indexed
  end

  it "can query on indexed text" do
    text = "mary had a little lamb\nlittle lamb little lamb\nits fleece was white or whatever"
    index = Index.new
    index.index_text(text, "mary") #returns # of lines indexed
    assert_equal ["mary:0:0"], index.query("mary")
  end

  it "tracks occurrences as objects" do
    text = "mary had a little lamb\nlittle lamb little lamb\nits fleece was white or whatever"
    index = Index.new
    index.index_text(text, "mary")
    assert_equal Occurrence, index.index["mary"].first.class
  end

  it "clears the index" do
    text = "mary had a little lamb\nlittle lamb little lamb\nits fleece was white or whatever"
    index = Index.new
    index.index_text(text, "mary")
    assert index.index.keys.any?
    index.clear
    refute index.index.keys.any?
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
end
