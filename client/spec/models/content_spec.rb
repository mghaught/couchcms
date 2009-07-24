require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Content do

  describe ".new" do
    
    it "return an instance of Content" do
      Content.new.should be_instance_of(Content)
    end
    
    it "initialize set parameters" do
      params = {:title => "MyTitle", :page => "PageData"}
      @content = Content.new(params)
      @content.title.should == "MyTitle"
      @content.page.should == "PageData"
    end
    
    it "initialize values to nil if not set" do
      @content = Content.new
      @content.title.should be_nil
      @content.page.should be_nil
    end
    
  end
  
  describe ".save" do
    describe "with an existing record" do
      before(:each) do
        @existing_content = existing_record
        @existing_content.id.should_not be_nil
        RestClient.stub!(:put)
      end
      
      it "returns true on a successful save" do
        @existing_content.save.should be_true
      end
      
      it "uses RestClient.put to pass on title and page values" do
        @url = "#{Content::REST_API_URI}/contents/#{@existing_content.id}.xml"
        @data = {:title => @existing_content.title, :page => @existing_content.page}
        RestClient.should_receive(:put).with(@url,:content => @data)
        @existing_content.save.should be_true
      end
      
      it "updates the rev and updated_at values" #do
      #   @old_rev = @existing_content.rev.dup
      #   @existing_content.save
      #   @old_rev.should_not == @existing_content.rev
      # end
      
    end
    
    describe "with a unsaved record" do
      
      before(:each) do
        RestClient.stub!(:post).and_return("<content><id>345</id></content>")
      end
      
      it "will return true for a successful save" do
        @content = Content.new(:title => "Save Me Again", :page => "...")
        @content.save.should be_true
      end
      
      
    end
  end
  
  def existing_record(params = {})
    existing_params = {:id => "1111", :rev => "1.1", :title => "Existing", :page => "data...", :created_at => 1.week.ago, 
      :updated_at => 5.minutes.ago}
    Content.new(existing_params.merge(params))
  end
end