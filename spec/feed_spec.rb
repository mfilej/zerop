require "spec_helper"

describe Feed do

  subject { Feed.new feed_fixture_url }

  describe "#videos" do
    it "sets guids as keys" do
      subject.videos.keys.should eq(%w[
        http://cdn/v/1
        http://cdn/v/2
        http://cdn/v/3
      ])
    end

    it "sets the attributes" do
      videos = subject.videos.values

      videos[0][:url].should eq("http://cdn/v/1")
      videos[0][:title].should eq("Castlevania: Symphony of the Night")
      videos[0][:pubdate].should eq("Wed, 11 May 2011 20:00:00 GMT")

      videos[1][:url].should eq("http://cdn/v/2")
      videos[1][:title].should eq("Portal 2")
      videos[1][:pubdate].should eq("Wed, 04 May 2011 20:00:00 GMT")

      videos[2][:url].should eq("http://cdn/v/3")
      videos[2][:title].should eq("Red Dead Redemption")
      videos[2][:pubdate].should eq("Wed, 09 Jun 2010 20:00:00 GMT")
    end
  end

end
