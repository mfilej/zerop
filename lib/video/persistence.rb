require "mongo"
require "ostruct"

module Persistence

  attr_writer :database

  def [](guid)
    return unless record = collection.find_one(guid: guid)
    OpenStruct.new(record)
  end

  def find(id)
    return unless record = collection.find_one(BSON::ObjectId(id))
    OpenStruct.new(record)
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

