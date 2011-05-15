require "mongo"
require "ostruct"

module Persistence

  attr_writer :database

  def [](guid)
    OpenStruct.new collection.find_one(guid: guid)
  end

  def find(id)
    OpenStruct.new collection.find_one(BSON::ObjectId(id))
  end

  def save(guid, attrs)
    collection.save attrs.merge(guid: guid)
  end

  def all
    collection.find.map { |e| OpenStruct.new(e) }
  end

  def collection
    @collection ||= @database["videos"]
  end

end

