require 'rest_client'
require 'xmlsimple'

class Content 
  
  ATTRIBUTES = %w{id rev title page created_at updated_at}
  ATTRIBUTES.each {|attribute| attr_accessor attribute}
  
  REST_API_URI = "http://localhost:3000"

  def initialize(data = {})
    hash = HashWithIndifferentAccess.new(data)
    ATTRIBUTES.each do |attribute|
      instance_variable_set("@#{attribute}".to_sym, hash[attribute])
    end
  end  
  
  def save
    data = {}
    data[:title] = title
    data[:page] = page
    if id
      RestClient.put "#{REST_API_URI}/contents/#{id}.xml", :content => data
#       doc = RestClient.get("#{REST_API_URI}/contents/#{id}.xml").to_s
# RAILS_DEFAULT_LOGGER.info "Refetched existing content data = #{doc}"      
#       set_attributes(XmlSimple.xml_in(doc))
# RAILS_DEFAULT_LOGGER.info "Set Attributes - #{self.inspect}"      
      true
    else
      results = RestClient.post "#{REST_API_URI}/contents.xml", :content => data
      doc = results.to_s    
      saved_content = Content.from_xml(doc) unless doc.blank?
      ATTRIBUTES.each do |attribute|
        send("#{attribute}=".to_sym,saved_content.send(attribute.to_sym)) if saved_content
      end      
      true
    end  
  end
  
# TODO this usually freezes attributes after deletion so they can't be changed
  def destroy
    RestClient.delete "#{REST_API_URI}/contents/#{id}.xml" 
    self
  end
  
  def update_attributes(data)
    set_attributes(data)
    save
  end
  
  def to_param
    id
  end
  
  def new_record?
    id.nil?
  end
  
  def self.all
    contents = []
    doc = RestClient.get("#{REST_API_URI}/contents.xml").to_s
    unless doc.blank?
      data = XmlSimple.xml_in(doc) 
      content_data = data["content"] 
      content_data.each do |cd|
        contents << from_hash(cd)
      end
    end
    contents
  end
  
  def self.find(id)
    return if id.blank?
    doc = RestClient.get("#{REST_API_URI}/contents/#{id}.xml").to_s
    from_xml(doc) unless doc.blank?
  end
  
  def self.from_hash(hash)
    return if hash.nil? || hash.empty?    
    data = {}
    ATTRIBUTES.each do |attribute|
      data[attribute] = hash[attribute][0] if hash[attribute] && !hash[attribute][0].blank?
    end
    Content.new(data)
  end

  def self.from_xml(document)
    self.from_hash(XmlSimple.xml_in(document))
  end  

private

  def set_attributes(data)
    hash = HashWithIndifferentAccess.new(data)
    ATTRIBUTES.each do |attribute|
      if hash[attribute]
        send("#{attribute}=".to_sym,hash[attribute]) 
      end  
    end
  end
end
