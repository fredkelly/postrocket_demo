class User
  include Mongoid::Document
  
  # OAuth fields
  field :uid,               type: String
  field :provider,          type: String
  field :oauth_token,       type: String
  field :oauth_expires_at,  type: DateTime
  
  field :email,       type: String
  field :first_name,  type: String
  field :last_name,   type: String
    
  index({ uid: 1 }, { unique: true, name: 'uid_index' })

  has_many :pages, dependent: :destroy
  
  def name
    "#{first_name} #{last_name}"
  end
  
  # init user from oauth
  def self.from_oauth(oauth)
    find_or_initialize_by(oauth.slice(:provider, :uid)).tap do |user|
      user.uid               = oauth.uid
      user.provider          = oauth.provider
      user.oauth_token       = oauth.credentials.token # original (short-lived) token
      user.oauth_expires_at  = Time.at(oauth.credentials.expires_at)
      user.attributes        = oauth.extra.raw_info.slice(*fields.keys)
      user.exchange_access_token! # get new token *before* loading pages
      user.load_pages!
      user.save!
    end
  end
  
  # koala instance
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end
  
  # get a 60-day token
  def exchange_access_token
    oauth = Koala::Facebook::OAuth.new(APP_CONFIG['facebook_app_id'], APP_CONFIG['facebook_secret'])
    oauth.exchange_access_token(oauth_token)
  end
  
  def exchange_access_token!
    self.oauth_token = exchange_access_token
    self.oauth_expires_at = 60.days.from_now.to_time
  end
  
  # retrieve user's pages from facebook
  # ensuring existing records are not overwritten
  def load_pages
    facebook.get_connections('me', 'accounts').map do |attrs|
      pages.find_or_initialize_by(id: attrs.delete('id')).tap do |page|
        page.attributes = attrs.slice(*Page.fields.keys)
      end
    end
  end
  
  def load_pages!
    self.pages = load_pages
    self.pages.map(&:save!)
  end
  
end
