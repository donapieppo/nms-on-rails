NmsOnRails.Views.Home ||= {}

# sostituito _.bindAll(this, 'addOne', 'addAll', 'render') con =>
class NmsOnRails.Views.Home.IndexView extends Backbone.View
  indexTemplate: JST["backbone/templates/home/index"]
    
  el: '#ips'

  initialize: (options) ->
    #console.log("inizializzato NmsOnRails.Views.Home.IndexView con")
    @net = options.net
    @ips = new NmsOnRails.Collections.IpsCollection()
    @ips.bind 'reset', @render
    @ips.url = "/ips?net=#{@net}"
    @ips.fetch()

  addOne: (ip) =>
    view = new NmsOnRails.Views.Ips.View(model : ip)
    @$("tbody").append(view.render().el)
		@

  addAll: () =>
    @ips.each(@addOne)
		@
   
  render: =>
    $(@el).html(@indexTemplate())
    @addAll()
    @

