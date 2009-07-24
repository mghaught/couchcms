class Content < CouchRestRails::Document
  
  property  :title
  property  :page
  
  timestamps!
  
  view_by :title
  view_by :created_at
  
  def to_param
    id
  end  
  
  def to_xml(options = {})
    options[:indent] ||= 2 unless RAILS_ENV == "production"
    options[:skip_instruct] = true if options[:builder]
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    
    xml.instruct! unless options[:skip_instruct]
    xml.content do
      xml.id            id
      xml.rev           rev
      xml.title         title
      xml.page          page
      xml.created_at    created_at.to_s(:db)
      xml.updated_at    updated_at.to_s(:db)
    end
  end
  
end


