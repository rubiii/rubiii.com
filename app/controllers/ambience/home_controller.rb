class Ambience::HomeController < ApplicationController

  caches_action :index, :cache_path => CachePath.join("ambience").to_s

  def index
    @articles = Article.all_by_category :ambience
  end

end