require "bundler"
Bundler.setup :default, :test

require "zero"
Zero.db = "zerop_test"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.after(:each, :db) { Episode.collection.remove }
end

def file_stub(file)
  "#{ File.expand_path "..", __FILE__ }/fixtures/#{ file }"
end
