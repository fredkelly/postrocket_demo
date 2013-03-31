class RealtimeUpdates < Koala::Facebook::RealtimeUpdates
  include Singleton
  
  def initialize
    super(app_id: APP_CONFIG['facebook_app_id'], secret: APP_CONFIG['facebook_secret'])
  end
end