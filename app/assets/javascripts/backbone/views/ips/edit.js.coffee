NmsOnRails.Views.Ips ||= {}
  
class NmsOnRails.Views.Ips.Edit extends Backbone.View
  ipEditTemplate: JST["backbone/templates/ips/edit"]
    
  el: 
    "#modaleditor"

  events:
    "click #ip-submit" : "close"

  render: =>
    $(@el).html(@ipEditTemplate(@model.toJSON())).modal('show')
    @

  close: (e) =>
    e.preventDefault()
    @model.get('info').save(name: $("#info-name").val(), comment: $("#info-comment").val(), ip_id : @model.get('id'))
                      .fail((x) => new NmsOnRails.Models.Error(x).display())
                      .done( => @model.change(); $(@el).modal('hide'); $(@el).unbind())


