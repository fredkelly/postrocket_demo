class Page
  include Mongoid::Document
  
  field :_id,           type: String # type override
  field :name,          type: String
  field :access_token,  type: String
  field :subscribed,    type: Boolean, default: false
  
  attr_accessible :id, :name, :access_token, :subscribed
    
  belongs_to :user
  embeds_many :posts
  
  alias :to_s :name
  
  def facebook
    @facebook ||= Koala::Facebook::API.new(access_token)
  end
  
  # subscribes to page's updates (currently irreversible)
  # https://developers.facebook.com/docs/reference/api/page/#realtime
  def add_to_tab
    facebook.put_connections(id, 'tabs', app_id: APP_CONFIG['facebook_app_id'])
  end
  after_create :add_to_tab

end