class HomeController < ApplicationController

  #caches_action :index, :layout => false, :cache_path => cache_path(:root)

  def index
    @articles = Article.all_by_category :root
  end

  def show
    @article = Article.find params[:id]
  end

end