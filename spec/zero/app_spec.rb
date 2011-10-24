require "spec_helper"
require "capybara/rspec"
require "rack/test"

Capybara.app = Zero::App
def app() Capybara.app end
include Rack::Test::Methods

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

feature "Update episode index", :db do
  background do
    ENV["episodes_update_token"] = "foobarbaz"
  end

  scenario "Requesting an update with an invalid token" do
    post "/update?token=wrong"

    last_response.status.should eq(403)
    last_response.body.should include("Invalid token")
  end

  scenario "Requesting an update with a valid token" do
    Parsed.should_receive :update_index

    post "/update?token=foobarbaz"

    last_response.status.should eq(200)
  end

end

# need to switch to rack-test since capybara treats the feed as html4
feature "Atom feed" do

  background do
    Episode[1] = { title: "Ep1", video_url: "http://video/1", pubdate: Time.utc(2011, 3, 10) }
    Episode[2] = { title: "Ep2", video_url: "http://video/2", pubdate: Time.utc(2011, 4, 10) }
  end

  scenario "Render the feed" do

    get "/feed.xml"

    feed = Nokogiri::XML last_response.body

    last_response.should be_ok
    last_response.content_type.should eq("application/atom+xml")

    feed.at_xpath("rss/channel/title").content.should eq("Zero Punctuation")
    feed.at_xpath("rss/channel/link").content.should eq("http://zerop.heroku.com")

    item = feed.at_xpath("rss/channel/item[1]")
    item.at_xpath("title").content.should eq("Ep2")
    item.at_xpath("pubDate").content.should eq("Sun, 10 Apr 2011 00:00:00 -0000")
    item.at_xpath("link").content.should eq("http://zerop.heroku.com/v/2")
    item.at_xpath("guid").content.should eq("http://zerop.heroku.com/v/2")

    item = feed.at_xpath("rss/channel/item[2]")
    item.at_xpath("title").content.should eq("Ep1")
    item.at_xpath("pubDate").content.should eq("Thu, 10 Mar 2011 00:00:00 -0000")
    item.at_xpath("link").content.should eq("http://zerop.heroku.com/v/1")
    item.at_xpath("guid").content.should eq("http://zerop.heroku.com/v/1")

  end

end
