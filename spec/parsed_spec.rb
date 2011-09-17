require "spec_helper"

describe Parsed do

  describe "#update_index", :db do
    it "adds missing videos" do
      Episode[1] = { title: "Ep1" }
      Episode[2] = { title: "Ep2" }

      Episode[3].should be_nil

      Parsed::Video.any_instance.stub(:url) { :noop }

      Parsed.update_index(<<-XML)
        <rss>
          <channel>
            <title>Zero Punctuation</title>
            <item>
              <title>Ep4</title>
              <link>http://cdn/v/4</link>
              <guid>http://cdn/v/4</guid>
              <pubDate>Wed, 14 May 2011 20:00:00 GMT</pubDate>
            </item>
            <item>
              <title>Ep3</title>
              <link>http://cdn/v/3</link>
              <guid>http://cdn/v/3</guid>
              <pubDate>Wed, 13 May 2011 20:00:00 GMT</pubDate>
            </item>
            <item>
              <title>Ep2</title>
              <link>http://cdn/v/2</link>
              <guid>http://cdn/v/2</guid>
              <pubDate>Wed, 12 May 2011 20:00:00 GMT</pubDate>
            </item>
          </channel>
        <rss>
      XML

      Episode[3]["title"].should eq("Ep3")
      Episode[3]["pubdate"].day.should eq(13)
      Episode[3]["page_url"].should eq("http://cdn/v/3")

      Episode[4]["title"].should eq("Ep4")
      Episode[4]["pubdate"].day.should eq(14)
      Episode[4]["page_url"].should eq("http://cdn/v/4")
    end
  end

end
