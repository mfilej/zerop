require "spec_helper"
require "parsed/feed"

describe Parsed::Feed do

  subject { described_class.new File.read(file_stub("feed.xml")) }

  describe "#videos" do
    it "returns an array videos" do
      video = subject.videos.first
      video.guid.should eq("http://cdn/v/1")
      video.title.should eq("Castlevania: Symphony of the Night")
      video.pubdate.should eq("Wed, 11 May 2011 20:00:00 GMT")
    end
  end

end
