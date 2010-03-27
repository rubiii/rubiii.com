require "rake"

class Savon::DocsController < ApplicationController

  def latest
    path = latest_docs_path
    path << params[:deep_link].join("/") if params[:deep_link]
    redirect_to_full_url path, 302
  end

private

  # Returns the path to the latest documentation.
  def latest_docs_path
    "/docs/" + FileList["public/docs/*"].last.split("/").last + "/"
  end

end
