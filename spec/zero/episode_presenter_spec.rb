require "spec_helper"

module Zero
  describe EpisodePresenter do
    subject do
      described_class.new "_id" => 1,
        "title" => "Episode",
        "pubdate" => Time.mktime(2011, 3, 9),
        "thumb_url" => "http://cdn.ex/th.jpg"
    end

    its(:id) { should eq(1) }
    its(:title) { should eq("Episode") }
    its(:time) { should eq(Time.mktime 2011, 3, 9) }
    its(:date) { should eq("Mar 9") }
    its(:url) { should eq("/e/1") }
    its(:thumb_url) { "http://cdn.ex/th.jpg" }
    its(:year) { should eq(2011) }
  end
end
