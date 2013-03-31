class PagesController < ApplicationController
  load_and_authorize_resource :through => :current_user
  respond_to :html, :json
  
  def index
    respond_with @pages
  end

  def show
  end
  
  def update
  end
end
