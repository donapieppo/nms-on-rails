NmsOnRails.Views.Home ||= {}

# sostituito _.bindAll(this, 'addOne', 'addAll', 'render') con =>
class NmsOnRails.Views.Home.IndexView extends Backbone.View
  indexTemplate: JST["backbone/templates/home/index"]
    
  el: '#ips'

  initialize: (options) ->
    @net = options.net_id
    @ips = new NmsOnRails.Collections.IpsCollection()
    @ips.on('reset', @render)
    @ips.url = "/nets/#{@net}/ips"
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

