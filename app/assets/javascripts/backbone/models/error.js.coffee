class NmsOnRails.Models.Error
  constructor:  (error) ->
    @error_json = jQuery.parseJSON(error.responseText)
    #console.log(@error_json)
    @

  display: ->
    alert(@)




    

