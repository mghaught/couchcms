class CurriculumContentsController < ApplicationController
  # GET /curriculum_contents
  # GET /curriculum_contents.xml
  def index
    @curriculum_contents = CurriculumContent.by_topic_id

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @curriculum_contents }
    end
  end

  # GET /curriculum_contents/1
  # GET /curriculum_contents/1.xml
  def show
    @curriculum_content = CurriculumContent.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @curriculum_content }
    end
  end

  # GET /curriculum_contents/new
  # GET /curriculum_contents/new.xml
  def new
    @curriculum_content = CurriculumContent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @curriculum_content }
    end
  end

  # GET /curriculum_contents/1/edit
  def edit
    @curriculum_content = CurriculumContent.get(params[:id])
  end

  # POST /curriculum_contents
  # POST /curriculum_contents.xml
  def create
    @curriculum_content = CurriculumContent.new(params[:curriculum_content])

    respond_to do |format|
      if @curriculum_content.save
        flash[:notice] = 'CurriculumContent was successfully created.'
        format.html { redirect_to(@curriculum_content) }
        format.xml  { render :xml => @curriculum_content, :status => :created, :location => @curriculum_content }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @curriculum_content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /curriculum_contents/1
  # PUT /curriculum_contents/1.xml
  def update
    @curriculum_content = CurriculumContent.get(params[:id])

    respond_to do |format|
      if @curriculum_content.update_attributes(params[:curriculum_content])
        flash[:notice] = 'CurriculumContent was successfully updated.'
        format.html { redirect_to(@curriculum_content) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @curriculum_content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /curriculum_contents/1
  # DELETE /curriculum_contents/1.xml
  def destroy
    @curriculum_content = CurriculumContent.get(params[:id])
    @curriculum_content.destroy

    respond_to do |format|
      format.html { redirect_to(curriculum_contents_url) }
      format.xml  { head :ok }
    end
  end
end
