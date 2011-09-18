require "spec_helper"
require "capybara/rspec"
require "rack/test"

Capybara.app = Zero::App

feature "Episode index", :db do
  background do
    Episode[1] = { title: "Review", video_url: "http://video.mp4",
                   pubdate: Time.utc(2011, 5, 1) }
    Episode[2] = { title: "Other Review", video_url: "http://vid.mp4",
                   pubdate: Time.utc(2011, 4, 24) }
  end

  scenario "Redirecting to the video" do
    visit "/"
    click_link "Review"

    page.current_url.should eq("http://video.mp4/")
  end

  scenario "Invalid episode id" do
    visit "/v/42"

    page.status_code.should eq(404)
  end
end

# need to switch to rack-test since capybara treats the feed as html4
describe Zero::App, :db do
  include Rack::Test::Methods
  let(:app) { described_class }

  describe "atom feed" do
    before do
      Episode[1] = { title: "Ep1", video_url: "http://video/1", pubdate: Time.utc(2011, 3, 10) }
      Episode[2] = { title: "Ep2", video_url: "http://video/2", pubdate: Time.utc(2011, 4, 10) }
    end

    before do
      get "/feed.xml"
    end

    let(:feed) { Nokogiri::XML last_response.body }

    it "responds with success" do
      last_response.should be_ok
    end

    it "responds with the proper content type" do
      last_response.content_type.should eq("application/atom+xml")
    end

    it "renders the channel tags" do
      feed.at_xpath("rss/channel/title").content.should eq("Zero Punctuation")
      feed.at_xpath("rss/channel/link").content.should eq("http://zerop.heroku.com")
    end

    it "renders the first item" do
      item = feed.at_xpath("rss/channel/item[1]")
      item.at_xpath("title").content.should eq("Ep2")
      item.at_xpath("pubDate").content.should eq("Sun, 10 Apr 2011 00:00:00 -0000")
      item.at_xpath("link").content.should eq("http://zerop.heroku.com/v/2")
      item.at_xpath("guid").content.should eq("http://zerop.heroku.com/v/2")
    end

    it "renders the second item" do
      item = feed.at_xpath("rss/channel/item[2]")
      item.at_xpath("title").content.should eq("Ep1")
      item.at_xpath("pubDate").content.should eq("Thu, 10 Mar 2011 00:00:00 -0000")
      item.at_xpath("link").content.should eq("http://zerop.heroku.com/v/1")
      item.at_xpath("guid").content.should eq("http://zerop.heroku.com/v/1")
    end

  end
end
