require "spec_helper"

describe Video do

  subject { Video.new video_fixture_url }

  describe "retrieve the config url from the video page" do
    its(:config_url) { should eq("http://somemedia.com/config.js") }
  end

  describe "retrieve the video url from the json config" do
    before :each do
      subject.stub(:config_url) { quasi_json_fixture_url }
    end

    its(:video_url) { should eq("http://video.somemedia.com/zp/3e8492.mp4") }
  end

  describe "persistence" do
    before :all do
      connection = Mongo::Connection.new
      @db = connection["zero_test"]
      Video.database = @db
    end

    before :each do
      @db.drop_collection "videos"
    end

    it "finds a record" do
      Video.collection.save guid: "id", title: "Title"

      record = Video.find("id")
      record["guid"].should eq("id")
      record["title"].should eq("Title")
    end

    it "saves a record" do
      Video.save "id", title: "Woo!"

      record = Video.collection.find_one guid: "id"
      record["guid"].should eq("id")
      record["title"].should eq("Woo!")
    end

    it "returns all records" do
      Video.save "id", title: "Vid"

      records = Video.all
      records[0]["title"].should eq("Vid")
    end
  end
end
