module Zero
  module EpisodePartial

    def render_episode(episode, detailed=false)
      haml :_episode, locals: { episode: episode, detailed: detailed }
    end

  end
end

