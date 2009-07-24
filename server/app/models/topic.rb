class Topic < CouchRestRails::Document
  
  property  :title
  property  :description

  timestamps!

  # validates_presence_of :title
  # validates_present :title
  
  
  view_by :title
  view_by :created_at

  
  def to_param
    id
  end
  
  def curriculum_contents 
    CurriculumContent.by_topic_id(:key => self.id)
  end

end
