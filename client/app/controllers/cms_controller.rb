# class CMSController < ApplicationController
#   allows :manager
#   uses_tiny_mce
# 
#   uses_tiny_mce :options =>
#     {
#       :theme => 'advanced',
#       :theme_advanced_resizing => true,
#       :theme_advanced_resize_horizontal => false,
#       #:plugins => %w{ table fullscreen }
#     }
# 
#   #uses_tiny_mce :only => [:new, :create, :edit, :update]
# 
# 
#   def index
#     @list = Content.list
#   end
# 
#   def edit
#     @basename = params[:id]
#     content = params[:content]
#     content = content[:content] if content.is_a?(Hash)
#   
#     if request.post?
#       @content = Content.new(@basename, content)
#       if @content.save
#         message "Content for #{ @basename.inspect } updated!", :class => "success"
#         redirect_to :action => :show, :id => @basename and return
#       end
#     end
# 
#     @content = Content.new(@basename, content)
#   end
# 
#   def show
#     @basename = params[:id]
#   end
# 
#   def new
#     @basename = params[:basename] || params[:id]
#     content = params[:content]
#     content = content[:content] if content.is_a?(Hash)
#     return unless @basename
# 
#     @basename = @basename.slug
# 
#     exists = Content.for(@basename) rescue false
# 
#     if exists
#       message "Sorry, content #{ @basename.inspect } already exists!", :class => "error"  
#       @basename = nil
#       return
#     end
# 
#     @content = Content.new(@basename, content)
# 
#     if(request.post?)
#       if(@content.save)
#         message "Content #{ @basename.inspect } created!", :class => "success"
#         redirect_to :action => :show, :id => @basename and return
#       else
#         message "Failed to save #{ @basename.inspect }", :class => "error"
#       end
#     end
#   end
# end
# CmsController=CMSController
