require "bundler"
Bundler.require

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "zero"

require "sinatra"
require "haml"

if ENV["MONGOHQ_URL"]
  uri = URI.parse(ENV["MONGOHQ_URL"])
  $mongo_connection = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
  db = uri.path[1..-1]
else
  $mongo_connection = Mongo::Connection.new
  db = "zero_development"
end

Video.database = $mongo_connection.db(db)

helpers do
  def video_url(video)
    url(%{/e/#{video._id}})
  end
end

get "/" do
  update_index
  @videos = Video.all

  headers "Cache-Control" => "public, max-age=900"
  haml :index
end

get "/e/:id" do |id|
  @video = Video.find(id)

  headers "Cache-Control" => "public",
          "Expires" => "Sun, 17-Jan-2038 19:14:07 GMT"
  haml :episode
end

get "/e/:id/v" do |id|
  url = Video.find(id).url
  video = Video.new(url)
  redirect to(video.video_url)
end

get "/feed.rss" do
  @videos = Video.all.reverse
  content_type :rss
  haml :feed, format: :xhtml
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
