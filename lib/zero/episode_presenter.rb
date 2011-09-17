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

    def date
      @episode["pubdate"].strftime "%b %-d"
    end

    def url
      "/e/#{id}"
    end

    def thumb_url
      @episode["thumb_url"]
    end

    def year
      @episode["pubdate"].year
    end

  end
end
