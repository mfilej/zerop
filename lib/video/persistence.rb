require "mongo"

module Persistence

  attr_writer :database

  def find(guid)
    collection.find_one guid: guid
  end

  def save(guid, attrs)
    collection.save attrs.merge(guid: guid)
  end

  def all
    collection.find.to_a
  end

  def collection
    @collection ||= @database["videos"]
  end

end

