class Content < CouchRestRails::Document
  
  property  :name
  property  :category_id
  property  :approved_by_id
  property  :data
  
  timestamps!
  
  view_by :name
  view_by :created_at
  view_by :language,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'Content' && doc['data']) {
          for(var i in doc.data) { 
            emit(i, doc.data[i]); 
          }
        }
      }"
  # to get all contents with en language versions    
  # Content.by_language :key => "en" 
  
  
  def to_param
    id
  end  
  
  def to_xml(options = {})
    options[:indent] ||= 2 unless RAILS_ENV == "production"
    options[:skip_instruct] = true if options[:builder]
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    
    xml.instruct! unless options[:skip_instruct]
    xml.content do
      xml.id                id
      xml.rev               rev
      xml.name              name
      xml.category_id       category_id
      xml.approved_by_id    approved_by_id
      xml.data              data.to_xml
      xml.created_at        created_at.to_s(:db)
      xml.updated_at        updated_at.to_s(:db)
    end
  end
  
  
  def languages
    data && data.is_a?(Hash) ? data.keys : ["None"]
  end
  
  
  
end


