class NmsOnRails.Routers.HomeRouter extends Backbone.Router
  routes:
    ""    : "index"
    "134" : "index"
    "135" : "index135"
    "132" : "index132"

  index: ->
    @view = new NmsOnRails.Views.Home.IndexView(net : 134)

  index135: ->
    @view = new NmsOnRails.Views.Home.IndexView(net : 135)

  index132: ->
    @view = new NmsOnRails.Views.Home.IndexView(net : 132)

