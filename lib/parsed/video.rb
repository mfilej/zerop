require "cgi"
require "json"

module Parsed
  class Video

    attr_reader :item

    def initialize(item)
      @item = item
    end

    def guid
      item.at("guid").inner_html
    end

    def pubdate
      item.at("pubDate").inner_html
    end

    def title
      item.at("title").inner_html
    end

    def link
      CGI.unescape item.at("link").inner_html
    end

    def url
      urls.video
    end

    def thumb
      urls.thumb
    end

    def urls
      @urls ||= URL.new(Nokogiri::HTML(open link))
    end

    class URL
      def initialize(page)
        @page = page
      end

      def config_url
        @page.at("object#player_api").at("param[name='flashvars']")["value"][7..-1]
      end

      def config
        JSON.parse open(config_url).read.tr!("'", '"')
      end

      def urls
        config["playlist"].map { |p| p["url"] }
      end

      def video
        urls.find { |u| u =~ /mp4$/ }
      end

      def thumb
        urls.find { |u| u =~ /jpg$/ }
      end
    end

  end
end
