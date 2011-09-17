module Zero
  module EpisodesHelper

    def episodes
      @episodes ||= Episode.newest_first.map { |e| EpisodePresenter.new(e) }
    end

    def latest_episodes
      episodes.first(3)
    end

    def episodes_by_year
      episodes.drop(3).group_by &:year
    end

  end
end


