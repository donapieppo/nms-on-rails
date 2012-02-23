class NmsOnRails.Models.Ip extends Backbone.Model
  paramRoot: 'ip'

  defaults:
    ip: null
    arp: null
    info: null
    conn_proto: null
    notify: null

  initialize: (attributes) ->
    @set(info : new NmsOnRails.Models.Info(@attributes.info))
    @set(arp  : new NmsOnRails.Models.Arp(@attributes.arp))

  conn_link: ->
    if @get('conn_proto')
      proto = @get('conn_proto')
      proto = 'html' if proto == 'http'
      "/ips/#{@get('id')}/connect.#{proto}"
    else 
      ""

  display_error: (error) ->
    # console.log(jQuery.parseJSON(error))
    # string = ""
    # JSON.parse(error, (key, value) ->  string = string + key + value)
    alert(jQuery.parseJSON(error).conn_proto)

  toggle_notify: ->
    url  = "/ips/#{@get('id')}/notify"
    Backbone.sync('update', @, {url : url, data : ""})
      .done( => @set(notify: ! @get('notify')))
      .fail( (x) -> console.log(x))

  toggle_protocol: ->
    protocol = switch @get('conn_proto')
                 when 'ssh'  then 'rdp'
                 when 'rdp'  then 'http'
                 when 'http' then 'ssh'
    url  = "/ips/#{@get('id')}/protocol"
    data = "protocol=#{protocol}"
    Backbone.sync('update', @, {url : url, data : data})
            .done( => @set(conn_proto: protocol))
            .fail((x) => @display_error(x.responseText))
      
class NmsOnRails.Collections.IpsCollection extends Backbone.Collection
  model: NmsOnRails.Models.Ip
  url: '/ips'



     
