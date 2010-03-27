require "spec_helper"

describe Savon::DocsController do

  it "should redirect to the latest docs" do
    get :latest
    
    response.location.should == latest_docs_path
  end

  it "should redirect deep links to the latest docs" do
    deep_link = ["classes", "Savon", "Client.html"]
    get :latest, :deep_link => deep_link
    
    response.location.should == latest_docs_path + deep_link.join("/")
  end

  # Returns the path to the latest documentation.
  def latest_docs_path
    "/docs/" + FileList["public/docs/*"].last.split("/").last + "/"
  end

end