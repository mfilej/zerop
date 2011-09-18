xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "Zero Punctuation"
    xml.description "Zero Punctuation episodes by Ben Yahtzee Croshaw"
    xml.link "http://zerop.heroku.com"
    xml.tag! "atom:link", href: request.url, rel: "self", type: "application/rss+xml"

    episodes.each do |episode|
      xml.item do
        xml.title episode.title
        xml.pubDate episode.time.rfc822
        xml.link episode.url
        xml.guid episode.url
      end
    end
  end
end

