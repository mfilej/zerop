namespace :episodes do
  $LOAD_PATH << File.expand_path("../lib", __FILE__)
  require "zero"
  Zero.db = "zerop_development"

  desc "Clears and reuilds the episodes index from given file"
  task :build do
    Parsed.build_index(STDIN.read)
  end

  task :update do
    Parsed.update_index(open Parsed::FEED_URL)
  end
end
