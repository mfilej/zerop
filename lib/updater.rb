require "net/http"

class Updater
  include Net

  def perform
    HTTP.post_form uri, token: token
  end

  protected

  def uri
    URI.parse "http://zerop.heroku.com/update"
  end

  def token
    ENV["episodes_update_token"]
  end

end
