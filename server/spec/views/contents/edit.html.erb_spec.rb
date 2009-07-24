require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contents/edit.html.erb" do
  include ContentsHelper
  
  before(:each) do
    assigns[:content] = @content = stub_model(Content,
      :new_record? => false
    )
  end

  it "renders the edit content form" do
    render
    
    response.should have_tag("form[action=#{content_path(@content)}][method=post]") do
    end
  end
end


