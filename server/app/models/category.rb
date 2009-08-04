class Category < CouchRestRails::Document
  
  property  :name
  property :foobar
  
  timestamps!
  
  view_by :name
  
  def to_param
    id
  end
  
end
