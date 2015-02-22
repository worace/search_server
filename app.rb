require "sinatra"
require "sinatra/json"
require_relative "lib/index"

class SampleServer < Sinatra::Base
  helpers Sinatra::JSON

  configure do
    set :index, Index.new
  end

  post "/query" do
    puts "received query request #{params}"
    result = case params[:query].split.length
             when 1
               index.query(params[:query])
             else
               puts "multiword query: #{params[:query]}"
               []
             end
    puts "got result #{result} for query #{params[:query]}"
    json result
  end

  delete "/index" do
    puts "DELETE /index -- clearing index"
    index.clear
    json "ok"
  end

  post "/index" do
    puts "Received index request: #{params.inspect}"
    name = params["file"][:filename]
    path = params["file"][:tempfile]
    json index_file(name, path)
  end

  def index_file(filename, filepath)
    index.index_text(File.read(filepath), filename)
  end

  def index
    settings.index
  end

  #def multi_query(string, origin = nil)
    #string_length = string.split.length
    #first_word = string.split.first
    #start_occurrences = index.fetch(first_word, [])
    #puts "checking possible start occurrences: #{start_occurrences}"
    #start_occurrences.select do |o|
      #puts "children of occurrence at location #{o.location} are #{o.children(string_length)}"
      #o.children(string_length).map(&:word).join(" ") == string
    #end
  #end
end

# the quick brown fox
# is oh so quick brown
#
# {"the" => [{"loc" => "0:0", "next" => "quick"}],
#  "quick" => [{"loc" => "0:1", "next" => "brown"},
#              {"loc" => "1:3", :next => "yay"}
#             ],
#  "brown" => [{"loc" => "0:2", "next" => "fox"}]
# }
