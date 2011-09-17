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

  end
end
