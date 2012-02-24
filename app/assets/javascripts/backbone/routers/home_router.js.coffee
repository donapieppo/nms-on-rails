class NmsOnRails.Routers.HomeRouter extends Backbone.Router
  routes:
    ""        : "default"
    ":net_id" : "index"

  initialize: (net_id) ->
    @default_net_id = net_id

  default: ->
    @view = new NmsOnRails.Views.Home.IndexView({net_id: @default_net_id})

  index: (net_id) ->
    @view = new NmsOnRails.Views.Home.IndexView({net_id: net_id})


