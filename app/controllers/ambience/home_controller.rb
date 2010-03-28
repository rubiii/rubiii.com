class Ambience::HomeController < ApplicationController

  ArticleCategory = :ambience

  def index
    @articles = Article.all_by_category ArticleCategory
  end

end