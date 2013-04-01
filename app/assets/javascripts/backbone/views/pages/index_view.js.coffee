PostRocket.Views.Pages ||= {}

class PostRocket.Views.Pages.IndexView extends Backbone.View
  template: JST["backbone/templates/pages/index"]

  initialize: () ->
    @options.pages.on('reset', @addAll)

  addAll: () =>
    @options.pages.each(@addOne)

  addOne: (page) =>
    view = new PostRocket.Views.Pages.PageView({model : page})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(pages: @options.pages.toJSON() ))
    @addAll()

    return this
