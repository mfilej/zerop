require "sinatra/base"

module Zero
  class App < Sinatra::Base

    set :public, "public"
    helpers EpisodesHelper, EpisodePartial

    get "/" do
      headers "Cache-Control" => "public, max-age=900"
      haml :index
    end

    get "/v/:id" do |id|
      episode = Episode[id]
      halt 404, "Not found" unless episode
      redirect to(episode["video_url"]), 301
    end

    get "/feed.xml" do
      content_type "application/atom+xml"
      builder :feed
    end

    get("/style.css") { sass :style }

  end
end
