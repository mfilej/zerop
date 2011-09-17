namespace :episodes do
  desc "Clears and reuilds the episodes index from given file"
  task :build do
    $LOAD_PATH << File.expand_path("../lib", __FILE__)
    require "zero"
    Zero.db = "zerop_development"
    Parsed.build_index(STDIN.read)
  end
end
