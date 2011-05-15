require "mongo"

module Persistence

  attr_writer :database

  def [](guid)
    collection.find_one guid: guid
  end

  def find(id)
    collection.find_one BSON::ObjectId(id)
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

