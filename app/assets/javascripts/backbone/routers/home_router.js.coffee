class NmsOnRails.Routers.HomeRouter extends Backbone.Router
  routes:
    ""    : "index"
    ":net_id" : "index"

  index: (net_id) ->
    @view = new NmsOnRails.Views.Home.IndexView({net_id: net_id})


