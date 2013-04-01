class PostRocket.Routers.PagesRouter extends Backbone.Router
  initialize: (options) ->
    @pages = new PostRocket.Collections.PagesCollection()
    @pages.reset options.pages

  routes:
    "index" : "index"
    ":id"   : "show"
    ".*"    : "index"

  index: ->
    @view = new PostRocket.Views.Pages.IndexView(pages: @pages)
    $("#pages").html(@view.render().el)

  show: (id) ->
    page = @pages.get(id)

    @view = new PostRocket.Views.Pages.ShowView(model: page)
    $("#pages").html(@view.render().el)