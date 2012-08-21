NmsOnRails.Views.Ips ||= {}

class NmsOnRails.Views.Ips.View extends Backbone.View
  ipViewTemplate: JST["backbone/templates/ips/ip"]
  
  events: 
    "click .dropdown-toggle" : "toggle_menu"
    "dblclick"        : "modaledit"
    "click .protocol" : "toggle_protocol"
    "click .notify"   : "toggle_notify"
    "click .wol"      : "fire_wol"
    "click .ip-reset" : "newinfo"
      
  tagName: "tr"
  
  initialize: ->
    @model.on('change', @render)

  render: =>
    $(@el).html(@ipViewTemplate(@model.toJSON()))
    @

  modaledit: ->
    @modaledit = new NmsOnRails.Views.Ips.Edit(model : @model)
    @modaledit.render()
    @

  toggle_menu: (e) ->
    menu = "<ul class='dropdown-menu'>" +
           "<li><a href='#{@model.conn_link()}' target='new'><i class='icon-eye-open'></i> Connect</a></li>" 
    if (@model.get('arp').get('mac'))
      menu = menu + "<li><a href='#{@model.wake_link()}' taget='new'><i class='icon-off'></i> Wake up</a></li>" 
    if (! @model.get('notify'))
      menu = menu + "<li><a href='#' class='notify'><i class='icon-time'></i> Notify when online</a></li>" 

    menu = menu + "<li class='divider'></li>"
    menu = menu + "<li><a href='#' class='ip-reset'><i class='icon-remove'></i> Reset</a></li>"
    menu = menu + "</ul>"
    $(@el).find('div').append(menu)

  toggle_notify: (e) ->
    e.preventDefault()
    @model.toggle_notify()
    alert('verrai notificato di conseguenza')

  toggle_protocol: (e) ->
    e.preventDefault()
    @model.toggle_protocol()

  newinfo: (e) ->
    e.preventDefault()
    if confirm('Are you absolutely sure you want to reset infos for this ip (they will be kept in history)?')
      info = new NmsOnRails.Models.Info(ip_id : @model.get('id'), dnsname : @model.get('info').get('dnsname'))
      info.save()
      @model.set(info: info)

  # old  fire_connection: -> window.open(@model.conn_link(), 'new')
  # with "click .connect"  : "fire_connection"

  fire_wol: ->
    link = "/ips/#{@model.get('id')}/wake.wol"
    window.open(link, 'new')
  

class NmsOnRails.Views.Ips.Edit extends Backbone.View
  ipEditTemplate: JST["backbone/templates/ips/edit"]
    
  el: 
    "#modaleditor"

  events:
    "click #ip-submit" : "close"

  render: =>
    $(@el).html(@ipEditTemplate(@model.toJSON())).modal('show').on('hide', =>
      console.log("SONO OFF")
      # @model.off()
      $(@el).off()
    )

  close: (e) =>
    e.preventDefault()
    @model.get('info').save(name: $("#info-name").val(), comment: $("#info-comment").val(), ip_id : @model.get('id'))
                      .fail((x) => alert(x))
                      .done( => @model.trigger('change'); $(@el).modal('hide'))


