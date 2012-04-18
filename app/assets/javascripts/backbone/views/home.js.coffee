NmsOnRails.Views.Home ||= {}

# sostituito _.bindAll(this, 'addOne', 'addAll', 'render') con =>
class NmsOnRails.Views.Home.IndexView extends Backbone.View
  indexTemplate: JST["backbone/templates/home/index"]
    
  el: '#ips'

  initialize: (options) ->
    @network = options.network_id
    @search_string = options.search_string
    @ips = new NmsOnRails.Collections.IpsCollection()
    @ips.on('reset', @render)
    @ips.url = "/networks/#{@network}/ips"
    @ips.fetch()

  # FIXME validate search_string
  show_search: (search_string) ->
    console.log("searching #{search_string}")
    @ips.url = "/ips?search_string=#{search_string}"
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

