class Ambience::HomeController < ApplicationController

  def index
    @articles = Article.all_by_category :ambience
  end

end