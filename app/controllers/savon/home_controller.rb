class Savon::HomeController < ApplicationController

  def index
    @articles = Article.all_by_category :savon
  end

end