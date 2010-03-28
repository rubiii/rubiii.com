class Savon::HomeController < ApplicationController

  caches_action :index, :cache_path => cache_path(:savon)

  def index
    @articles = Article.all_by_category :savon
  end

end