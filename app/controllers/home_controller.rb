class HomeController < ApplicationController

  def index
    @articles = Article.all_by_category :root
  end

  def show
    @article = Article.find params[:id]
  end

end