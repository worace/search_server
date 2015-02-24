class Index
  attr_reader :index
  def initialize
    @index = {}
  end

  def index_text(text, filename = nil)
    prev = nil
    text.split("\n").each_with_index do |line, l_index|
      words = line.split
      words.each_with_index do |word, w_index|
        occurrence = Occurrence.new(word, "#{filename}:#{l_index}:#{w_index}")
        if prev
          prev.neighbor = occurrence
        end
        prev = occurrence
        if index[word].nil?
          index[word] = [occurrence]
        else
          index[word] << occurrence
        end
      end
    end.count
  end

  def clear
    index.clear
  end

  def query(string)
    words = string.split
    index.fetch(words.first, []).select do |o|
      [o.word] + o.children(words.length - 1).map(&:word) == words
    end.map(&:location)
  end
end

class Occurrence < Struct.new(:word, :location, :neighbor)
  def to_s
    "Occurrence of #{word} at location #{location}; next word: #{neighbor.word}"
  end

  def inspect
    to_s
  end

  def children(count = 0)
    if count == 0 || neighbor.nil?
      []
    else
      [neighbor] + neighbor.children(count - 1)
    end
  end
end

