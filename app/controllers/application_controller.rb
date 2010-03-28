class ApplicationController < ActionController::Base

  CachePath = Rails.root.join("public", "cache")

  helper :all
  protect_from_forgery

protected

  def self.cache_path(subfolder = nil)
    path = CachePath
    path.join(subfolder.to_s) if subfolder
    path.to_s
  end

end