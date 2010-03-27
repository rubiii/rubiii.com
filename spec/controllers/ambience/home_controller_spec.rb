require "spec_helper"

describe Ambience::HomeController do
  integrate_views

  it "should render the :index template" do
    get :index
    
    response.should be_success
    response.should render_template(:index)
  end

end