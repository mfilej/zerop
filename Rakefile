$LOAD_PATH << File.expand_path("../lib", __FILE__)

namespace :episodes do
  require "zero"
  Zero.db = ENV["MONGOHQ_URL"] || "zerop_development"

  desc "Clears and reuilds the episodes index from given file"
  task :build do
    Parsed.build_index(STDIN.read)
  end

  desc "Updates the index with new episodes"
  task :update do
    Parsed.update_index(open Parsed::FEED_URL)
  end
end

desc "Pings the web app to check for updates"
task :updater do
  require "updater"
  Updater.new.perform
end
