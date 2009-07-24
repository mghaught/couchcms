require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contents/new.html.erb" do
  include ContentsHelper
  
  before(:each) do
    assigns[:content] = stub_model(Content,
      :new_record? => true
    )
  end

  it "renders new content form" do
    render
    
    response.should have_tag("form[action=?][method=post]", contents_path) do
    end
  end
end


