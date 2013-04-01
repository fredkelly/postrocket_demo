class FacebookUpdatesController < ApplicationController
  skip_authorization_check
  
  layout nil
    
  # handles updates
  def create
    output = { text: nil }
    
    begin
      # extract message
      update = params['facebook_update']
    
      # if we've not got a page, exit
      raise "unexpected object type" if update['object'] != 'page'
      
      # add each updated page (may be multiple)
      update['entry'].each do |entry|
        
        # find the page
        page = Page.where(id: entry['id']).first
        
        # skip if non-existent, or not subscribed to
        next unless page and page.subscribed?
        
        # for each recorded change
        entry['changes'].each do |change|
          id = change['value']['post_id'].split('_')[-1] rescue next
          
          # save the post to the associated page
          page.posts.find_or_initialize_by(id: id).tap do |post|
            post.created_at = Time.at(entry['time'])
            post.save!
          end
        end
        
      end
    rescue Exception => error
      raise error unless Rails.env.production?
      output[:status] = 400
    end
    
    render output
  end
  
  # responds to verification request
  def index
    render text: Koala::Facebook::RealtimeUpdates.meet_challenge(params, APP_CONFIG['realtime_token'])
  end
end