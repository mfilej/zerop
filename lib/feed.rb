require "date"

class Feed

  def initialize(url)
    @url = url
  end

  def xml
    @xml ||= Nokogiri::XML(open @url)
  end

  def videos
    @videos ||= xml.search("item").each_with_object({}) do |item, hash|
      hash[key(item)] = params(item)
    end
  end

  def key(item)
    item.at("guid").inner_html
  end

  def params(item)
    {}.tap do |attrs|
      attrs[:url]     = CGI.unescape item.at("link").inner_html
      attrs[:title]   = item.at("title").inner_html
      attrs[:pubdate] = item.at("pubDate").inner_html
    end
  end

end

