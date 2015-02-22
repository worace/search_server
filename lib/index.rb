class Index
  attr_reader :index
  def initialize
    @index = {}
  end

  def index_text(text, filename = nil)
    text.split("\n").each_with_index do |line, l_index|
      words = line.split
      words.each_with_index do |word, w_index|
        occurrence = Occurrence.new(word, "#{filename}:#{l_index}:#{w_index}")
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
    index.fetch(string, []).map(&:location)
  end
end

class Occurrence < Struct.new(:word, :location, :neighbor)
  def children(count = 0)
    if count == 0 || neighbor.nil?
      []
    else
      [neighbor] + neighbor.children(count - 1)
    end
  end
end

