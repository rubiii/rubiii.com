class Ambience::HomeController < ApplicationController

  caches_action :index, :cache_path => cache_path(:ambience)

  def index
    @articles = Article.all_by_category :ambience
  end

end