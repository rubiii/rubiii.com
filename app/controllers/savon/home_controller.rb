class Savon::HomeController < ApplicationController

  caches_action :index, :cache_path => CachePath.join("savon").to_s
  def index
    @articles = Article.all_by_category :savon
  end

end