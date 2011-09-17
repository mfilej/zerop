require "spec_helper"
require "rack/test"

module Zero
  describe App do
    include Rack::Test::Methods
    let(:app) { described_class }

    describe "/" do
      it "responds with success" do
        #get "/"
        #last_response.should be_ok
      end
    end

    describe "/v/:id" do
      it "redirects to the episode url", :db do
        Episode[14] = { video_url: "http://example.cdn/v.mp4" }
        get "/v/14"

        last_response.status.should eq(301)
        follow_redirect!
        last_request.url.should eq("http://example.cdn/v.mp4")
      end

      it "responds with not found" do
        get "/v/42"
        last_response.status.should eq(404)
      end
    end

    describe "/feed.xml", :db do
      let(:feed) { Nokogiri::XML(last_response.body) }

      it "renders the atom feed" do
        Episode[1] = { title: "Ep1", video_url: "http://video/1", pubdate: Time.utc(2011, 3, 10) }
        Episode[2] = { title: "Ep2", video_url: "http://video/2", pubdate: Time.utc(2011, 4, 10) }
        Episode[3] = { title: "Ep3", video_url: "http://video/3", pubdate: Time.utc(2011, 5, 10) }

        get "/feed.xml"

        last_response.should be_ok

        items = feed.search("item")
        items[0].at("title").content.should eq("Ep3")
        items[0].at("link").content.should eq("http://zerop.heroku.com/v/3")
        items[0].at("guid").content.should eq("/v/3")
        items[0].at("pubDate").content.should eq("Tue, 10 May 2011 00:00:00 -0000")

        items[1].at("title").content.should eq("Ep2")
        items[1].at("link").content.should eq("http://zerop.heroku.com/v/2")
        items[1].at("guid").content.should eq("/v/2")
        items[1].at("pubDate").content.should eq("Sun, 10 Apr 2011 00:00:00 -0000")

        items[2].at("title").content.should eq("Ep1")
        items[2].at("link").content.should eq("http://zerop.heroku.com/v/1")
        items[2].at("guid").content.should eq("/v/1")
        items[2].at("pubDate").content.should eq("Thu, 10 Mar 2011 00:00:00 -0000")
      end
    end

  end
end
