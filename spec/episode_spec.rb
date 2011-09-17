require "spec_helper"

describe Episode, :db do

  it "queries collection by _id" do
    Episode.save _id: 100, title: "VVVVV"

    Episode["100"]["title"].should eq("VVVVV")
  end

  it "stores the document by given id" do
    Episode["66"] = { title: "Portal" }

    Episode.find_one(_id: 66)["title"].should eq("Portal")
  end

  it "retrieves documents with latest pubdate first" do
    Episode[10] = { pubdate: Time.mktime(2008) }
    Episode[11] = { pubdate: Time.mktime(2009) }

    result = Episode.newest_first.to_a

    result[0]["pubdate"].year.should eq(2008)
    result[1]["pubdate"].year.should eq(2007)
  end

end

