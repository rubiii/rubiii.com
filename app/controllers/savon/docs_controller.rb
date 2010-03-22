class Savon::DocsController < ApplicationController

  def latest
    path = "/docs/0.7.6/"
    path << params[:deep_path].join("/") if params[:deep_path]
    redirect_to_full_url path, 302
  end

end
