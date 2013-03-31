class User
  include Mongoid::Document
  
  # OAuth fields
  field :uid,               type: String
  field :provider,          type: String
  field :oauth_token,       type: String
  field :oauth_expires_at,  type: DateTime
  
  field :first_name,  type: String
  field :last_name,   type: String
  
  index({ uid: 1 }, { unique: true, name: 'uid_index' })
  
  # pages managed
  embeds_many :pages
  
  def name
    "#{first_name} #{last_name}"
  end
  
  # init user from oauth
  def self.from_oauth(oauth)
    find_or_initialize_by(oauth.slice(:provider, :uid)).tap do |user|
      user.uid               = oauth.uid
      user.provider          = oauth.provider
      user.oauth_token       = oauth.credentials.token
      user.oauth_expires_at  = Time.at(oauth.credentials.expires_at)
      user.attributes        = oauth.extra.raw_info.slice(*fields.keys)
      user.save!
    end
  end
  
  # koala instance
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end
  
  # retrieve user's pages from facebook
  def load_pages
    facebook.get_connections('me', 'accounts').map do |attrs|
      pages.find_or_initialize_by(page_id: attrs['id']).tap do |page|
        page.attributes = attrs.slice(*Page.fields.keys)
      end
    end
  end
  
  def load_pages!
    load_pages; save!
  end
  
end
