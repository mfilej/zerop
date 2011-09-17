require "spec_helper"

module Parsed
  describe Video do
    let :feed do
      Nokogiri::XML(<<-DOC)
        <item>
          <title>Castlevania: Symphony of the Night</title>
          <link>http://cdn/v/1</link>
          <guid>http://cdn/v/1</guid>
          <description><![CDATA[<p>This week</p>]]></description>
          <pubDate>Wed, 11 May 2011 20:00:00 GMT</pubDate>
          <dc:creator>Ben "Yahtzee" Croshaw</dc:creator>
          <category>Zero Punctuation</category>
        </item>
      DOC
    end

    subject { described_class.new feed.at("item") }

    its(:guid) { should eq("http://cdn/v/1") }
    its(:pubdate) { should eq("Wed, 11 May 2011 20:00:00 GMT") }
    its(:title) { should eq("Castlevania: Symphony of the Night") }
    its(:link) { should eq("http://cdn/v/1") }

    it "" do
      subject.stub(:open) { <<-HTML }
        <object id="player_api">
          <param name="flashvars" value="path/to#{ file_stub 'config.qjson' }">
        </object>
      HTML

      subject.url.should eq("http://video.somemedia.com/zp/3e8492.mp4")
      subject.thumb.should eq("http://www.themis-media.com/global/media/images/library/deriv/29/29322.jpg")
    end
  end

  describe Video::URL do
    subject { described_class.new Nokogiri::HTML(open file_stub("video.html")) }

    it "retrieves the config url from the video page" do
      subject.config_url.should eq("http://somemedia.com/config.js")
    end

    before :each do
      subject.stub(:config) { JSON.parse(<<-JSON) }
        {"playlist":[
          {"url":"http://cdn.example/img/293.jpg","scaling":"fit"},
          {"url":"http://cdn.example/293.mp4","autoPlay":false,"scaling":"fit"}
        ]}
      JSON
    end

    it "retrieves the video url from the json config" do
      subject.video.should eq("http://cdn.example/293.mp4")
    end

    it "retrieves the thumbnail url from the json config" do
      subject.thumb.should eq("http://cdn.example/img/293.jpg")
    end
  end

end
