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