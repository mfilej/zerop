require "zero"

def fixture_url(file)
  "#{ File.expand_path "..", __FILE__ }/fixtures/#{ file }"
end

def video_fixture_url
  fixture_url "video.html"
end

def quasi_json_fixture_url
  fixture_url "config.qjson"
end

def feed_fixture_url
  fixture_url "feed.xml"
end


