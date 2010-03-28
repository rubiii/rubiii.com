require "spec_helper"

describe Savon::HomeController do
  integrate_views

  it "should have an ArticleCategory constant holding the category to fetch articles for" do
    Savon::HomeController::ArticleCategory.should == :savon
  end

  it "should render the :index template" do
    get :index
    
    response.should be_success
    response.should render_template(:index)
  end

  it "should assign a list of @articles" do
    get :index
    
    assigns[:articles].should be_an(Array)
  end

end