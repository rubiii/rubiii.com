require "spec_helper"

describe HomeController do

  it "should render the :index template" do
    response.should be_success
    response.should render_template(:index)
  end

end