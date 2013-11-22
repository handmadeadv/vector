Template.welcome.events
  'submit form': (e,t) ->
    e.preventDefault()
    email = t.find('#vectorLoginEmail').value
    password = t.find('#vectorLoginPassword').value
    Meteor.loginWithPassword email, password, (error) ->
      if error
        Notifications.send Vector.settings.defaultLoginErrorWarning
      else 
        Notifications.send Vector.settings.defaultLoginSuccess