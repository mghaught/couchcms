class CurriculumContent < CouchRestRails::Document

  property  :topic_id
  property  :research_stage
  property  :content_item
  property  :language
  property  :grade_range
  
  timestamps!
  
  view_by :topic_id

  # validates_present :topic_id
  
  def to_param
    id
  end
  
  def topic
    Topic.get(topic_id)
  end
  
end
