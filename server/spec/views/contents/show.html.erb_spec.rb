require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contents/show.html.erb" do
  include ContentsHelper
  before(:each) do
    assigns[:content] = @content = stub_model(Content)
  end

  it "renders attributes in <p>" do
    render
  end
end

