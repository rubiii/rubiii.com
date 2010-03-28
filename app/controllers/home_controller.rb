class HomeController < ApplicationController

  caches_action :index, :cache_path => CachePath.join("root")

  def index
    @articles = Article.all_by_category :root
  end

  def show
    @article = Article.find params[:id]
  end

end