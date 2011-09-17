require "date"

module Parsed
  class Feed

    def initialize(feed)
      @xml = Nokogiri::XML(feed)
    end

    def videos
      @xml.search("item").map { |item| Video.new(item) }
    end

  end
end
