class Post
  include Mongoid::Document
  
  embedded_in :page
  
  field :_id,         type: String
  field :created_at,  type: DateTime
  field :object,      type: Hash
  
  attr_accessible :id, :created_at
    
  # save the post details
  before_create do |post|
    self.object = page.facebook.get_object(id)
  end
  
  # schedule emails
  after_create do |post|
    # 1. schedule new post email asap
    self.class.delay.deliver_email(post.page.id, post.id, :new_post)
    # 2. schedule insights email in 24.hours
    self.class.delay(run_at: 1.minute.from_now).deliver_email(post.page.id, post.id, :post_stats)
  end
  
  # to be run by delayed_job
  def self.deliver_email(page_id, post_id, email_type)
    post = Page.find(page_id).posts.where(id: post_id).first
    raise "couldn't get post with id=#{post_id}" if post.nil?
    UserMailer.send(email_type, post).deliver
  end

  def insights
    # which metrics to get?
    metrics = {
      insights: %w(post_impressions_organic_unique post_impressions_viral_unique post_stories),
      post: %w(comments likes)
    }
    
    # get data from facebook
    insights, post = page.facebook.batch do |batch_api|
      batch_api.get_connections("#{page.id}_#{id}", "insights/#{metrics[:insights].join(',')}")
      batch_api.get_object(id, fields: metrics[:post])
    end
    
    # tidy up!
    Hash[
      insights.map {|d| [d['name'], d['values'].first['value']]} +
      metrics[:post].map{|k| [k, post.has_key?(k) ? post[k]['data'].size : 0]}
    ]
  end

end
