class PagesController < ApplicationController
  before_filter :as_document, :only => :show
  load_and_authorize_resource :through => :current_user
  respond_to :html, :json
  
  def index
    respond_with @pages
  end

  def show
    @page.posts = @page.posts.sort_by{|p| p.id}
    respond_with @page
  end
  
  def update
    @page.update_attributes(params[:page])
    respond_with @page
  end
  
  def as_document
    @page = @page.as_document if request.format.js?
  end
end
