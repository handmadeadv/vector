Template.welcome.helpers
  services: ->
    if @field.options and @field.options.services
      services = []
      _services = @field.options.services
      for i,service of _services
        services.push
          name: _services[i]
      services

Template.welcome.events
  'submit form': (e,t) ->
    e.preventDefault()
    email = t.find('#vectorLoginEmail').value
    password = t.find('#vectorLoginPassword').value
    Meteor.loginWithPassword email, password, (error) ->
      if error
        Vector.notifications.send Vector.settings.defaultLoginErrorWarning
      else 
        Vector.notifications.send Vector.settings.defaultLoginSuccess
  'click .vectorLoginService': (e,t) ->
    e.preventDefault()
    service = e.target.getAttribute 'id'
    if service
      serviceName = service.replace "vectorLogin_", ""
      serviceName = serviceName.charAt(0).toUpperCase() + serviceName.slice(1)
      methodName = "loginWith" + serviceName
      Meteor[methodName]( (error) ->
        if error
          Vector.notifications.send Vector.settings.defaultLoginErrorWarning
        else 
          Vector.notifications.send Vector.settings.defaultLoginSuccess
      )