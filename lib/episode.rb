require "forwardable"

class Episode

  class << self
    extend Forwardable
    def_delegators :collection, :save, :find, :find_one

    def collection
      @collection ||= Zero.db_connection["episodes"].tap do |c|
        c.create_index([[:pubdate, -1]])
      end
    end

    KEY = "_id"

    def [](id)
      find_one(KEY => id.to_i)
    end

    def []=(id, attrs)
      save attrs.merge(KEY => id.to_i)
    end

    def newest_first
      find.sort ['pubdate', -1]
    end

    def latest(num)
      newest_first.limit(num)
    end
  end

end
