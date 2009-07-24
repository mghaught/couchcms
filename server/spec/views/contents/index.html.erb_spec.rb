require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contents/index.html.erb" do
  include ContentsHelper
  
  before(:each) do
    assigns[:contents] = [
      stub_model(Content),
      stub_model(Content)
    ]
  end

  it "renders a list of contents" do
    render
  end
end

