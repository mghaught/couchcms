require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContentsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "contents", :action => "index").should == "/contents"
    end
  
    it "maps #new" do
      route_for(:controller => "contents", :action => "new").should == "/contents/new"
    end
  
    it "maps #show" do
      route_for(:controller => "contents", :action => "show", :id => "1").should == "/contents/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "contents", :action => "edit", :id => "1").should == "/contents/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "contents", :action => "create").should == {:path => "/contents", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "contents", :action => "update", :id => "1").should == {:path =>"/contents/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "contents", :action => "destroy", :id => "1").should == {:path =>"/contents/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/contents").should == {:controller => "contents", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/contents/new").should == {:controller => "contents", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/contents").should == {:controller => "contents", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/contents/1").should == {:controller => "contents", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/contents/1/edit").should == {:controller => "contents", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/contents/1").should == {:controller => "contents", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/contents/1").should == {:controller => "contents", :action => "destroy", :id => "1"}
    end
  end
end
