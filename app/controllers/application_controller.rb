class ApplicationController < ActionController::Base

  CachePath = Rails.root.join("public", "cache")

  helper :all
  protect_from_forgery

protected

  def cache_path(subfolder = nil)
    cache_path = CachePath
    cache_path.join(subfolder.to_s) if subfolder
    cache_path.to_s
  end

end