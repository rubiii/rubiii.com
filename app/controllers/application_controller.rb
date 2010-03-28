class ApplicationController < ActionController::Base

  #CachePath = Rails.root.join("public", "cache")

  helper :all
  protect_from_forgery

end