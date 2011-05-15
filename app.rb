$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "zero"

require "sinatra"
require "haml"

Video.database = Mongo::Connection.new["videos"]

get "/" do
  update_index
  @videos = Video.all
  haml :index
end

get "/e/:id" do |id|
  @video = Video.find(id)
  @video.title
end

def update_index
  feed.videos.each do |key, attrs|
    next if Video[key]

    Video.save(key, attrs)
  end
end

def feed
  @feed ||= Feed.new("http://www.escapistmagazine.com/rss/videos/list/1.xml")
end
