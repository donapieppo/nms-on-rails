class NmsOnRails.Routers.HomeRouter extends Backbone.Router
  routes:
    ""            : "default"
    ":network_id" : "index"

  initialize: (network_id) ->
    @default_network_id = network_id

  default: ->
    @view = new NmsOnRails.Views.Home.IndexView({network_id: @default_network_id})

  index: (network_id) ->
    @view = new NmsOnRails.Views.Home.IndexView({network_id: network_id})


