require "sinatra/base"

module Zero
  class App < Sinatra::Base

    helpers do
      def latest_episodes
        Episode.latest(3).map { |e| EpisodePresenter.new(e) }
      end

      def episodes_by_year
        episodes = Episode.newest_first.skip(3)
        episodes.map { |e| EpisodePresenter.new(e) }.group_by &:year
      end

      def render_episode(episode, detailed=false)
        haml :_episode, locals: { episode: episode, detailed: detailed }
      end
    end

    get "/" do
      # update_index

      headers "Cache-Control" => "public, max-age=900"
      haml :index
    end

    get "/v/:id" do |id|
      episode = Episode[id]
      halt 404, "Not found" unless episode
      redirect to(episode["video_url"]), 301
    end

    get "/feed.rss" do
      @videos = Video.all.reverse
      content_type :rss
      haml :feed, format: :xhtml
    end

    get("/style.css") { sass :style }
  end
end
