PostRocket.Views.Pages ||= {}

class PostRocket.Views.Pages.PageView extends Backbone.View
  template: JST["backbone/templates/pages/page"]
  
  initialize: ->
    @model.on('change:subscribed', @render, @)
  
  events:
    "click input[name=subscribe]" : "toggleSubscribe"

  tagName: "tr"

  toggleSubscribe: () ->
    @model.set(subscribed: !@model.get('subscribed'))
    @model.save()

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this
