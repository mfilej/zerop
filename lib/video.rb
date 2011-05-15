require "video/persistence"

class Video
  extend Persistence

  attr_reader :page_url

  def initialize(page_url)
    @page_url = page_url
  end

  def page
    @page ||= Nokogiri::XML(open page_url)
  end

  def config_url
    page.at("object#player_api").at("param[name='flashvars']")["value"][7..-1]
  end

  def config
    JSON.parse open(config_url).read.tr!("'", '"')
  end

  def video_url
    config["playlist"].find do |p|
      p["url"] =~ /mp4$/
    end["url"]
  end

end

