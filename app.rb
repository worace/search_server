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
    result = index.query(params[:query])
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
end
