class PostRocket.Models.Page extends Backbone.Model
  paramRoot: 'page'
  defaults:
    name: 'New Page'
    subscribed: false
    pages: []

class PostRocket.Collections.PagesCollection extends Backbone.Collection
  model: PostRocket.Models.Page
  url: '/pages'
