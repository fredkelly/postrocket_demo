class Page
  include Mongoid::Document
  
  field :page_id,       type: String
  field :name,          type: String
  field :access_token,  type: String
  field :subscribed,    type: Boolean, default: false
  
  embedded_in :user
end