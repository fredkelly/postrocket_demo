class UserMailer < ActionMailer::Base  
  default from: 'demo@getpostrocket.com'
  layout 'mailer_default'
  
  def new_post(post)
    @post, @user = post, post.page.user

    mail to: @user.email, subject: "#{@post.page}: New Post"
  end

  def post_stats(post)
    @post, @user = post, post.page.user
    @insights = @post.insights

    mail to: @user.email, subject: "#{@post.page}: Insights"
  end
  
end
