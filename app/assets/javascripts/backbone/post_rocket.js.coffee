#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

# setup for MongoDB
Backbone.Model.prototype.idAttribute = '_id'

window.PostRocket =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}