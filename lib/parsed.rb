require "nokogiri"
require "date"

module Parsed
  extend self

  autoload :Feed,  "parsed/feed"
  autoload :Video, "parsed/video"

  FEED_URL = "http://www.escapistmagazine.com/rss/videos/list/1.xml"

  def update_index(feed)
    Feed.new(feed).videos.each do |video|
      id = episode_id(video.guid)
      next if Episode[id]

      Episode[id] = {
        title: video.title,
        pubdate: Time.parse(video.pubdate),
        video_url: video.url,
        page_url: video.link,
        thumb_url: video.thumb
      }
    end
  end

  def build_index(input)
    Zero.db_connection.drop_collection("episodes")

    input.each_line do |line|
      next unless line =~ /^http/

      video_url, page_url, thumb_url, year, month, day, title = line.split "\t"

      id = episode_id(page_url)
      pubdate = Time.mktime(year.to_i, month.to_i, day.to_i)

      Episode[id] = {
        title: title,
        pubdate: pubdate,
        video_url: video_url,
        page_url: page_url,
        thumb_url: thumb_url
      }
    end
  end

  private

  def episode_id(url)
    url.match(%r{/([^/]+)$})[1].to_i
  end

end
