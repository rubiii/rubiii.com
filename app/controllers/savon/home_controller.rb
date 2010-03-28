class Savon::HomeController < ApplicationController

  ArticleCategory = :savon

  def index
    @articles = Article.all_by_category ArticleCategory
  end

end