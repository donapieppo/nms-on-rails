NmsOnRails.Views.Ips ||= {}

class NmsOnRails.Views.Ips.View extends Backbone.View
  ipViewTemplate: JST["backbone/templates/ips/ip"]
  
  events: 
    "dblclick"        : "modaledit"
    "click .protocol" : "toggle_protocol"
    "click .connect"  : "fire_connection"
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

  fire_connection: ->
    window.open(@model.conn_link(), 'new')

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


