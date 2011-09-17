require "nokogiri"
require "open-uri"
require "mongo"

autoload :Parsed, "parsed"
autoload :Episode, "episode"

module Zero
  autoload :App, "zero/app"
  autoload :EpisodePresenter, "zero/episode_presenter"

  class << self
    attr_accessor :db

    def db_connection
      return @db_connection if @db_connection
      raise "set Zero.db before attempting to get a db connection" unless db
      # stolen from Mingo
      if db.index('mongodb://') == 0
        @db_connection = Mongo::Connection.from_uri(db)
        connection.db(connection.auths.last['db_name'])
      else
        @db_connection = Mongo::Connection.new.db(db)
      end
    end
  end

end
