class SessionsController < ApplicationController
  skip_authorization_check
  
  def create
    session[:user_id] = User.from_oauth(env['omniauth.auth']).id
    flash[:success] = 'You are now logged in.'
    redirect_to(root_url)
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to(root_url, notice: 'You are now logged out.')
  end
  
end