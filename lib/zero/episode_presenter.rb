module Zero
  class EpisodePresenter

    def initialize(episode)
      @episode = episode
    end

    def id
      @episode["_id"]
    end

    def title
      @episode["title"]
    end

    def time
      @episode["pubdate"]
    end

    def date
      time.strftime "%b %-d"
    end

    def year
      time.year
    end

    def path
      "/v/#{id}"
    end

    def url
      "http://zerop.heroku.com#{path}"
    end

    def thumb_url
      @episode["thumb_url"]
    end

  end
end
