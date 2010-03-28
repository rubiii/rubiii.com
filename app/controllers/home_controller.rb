class HomeController < ApplicationController

  ArticleCategory = :root

  def index
    @articles = Article.all_by_category ArticleCategory
  end

  def show
    @article = Article.find params[:id]
  end

end