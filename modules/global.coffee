Vector.notifications = 
  timeout: null
  send: (message,type) ->
    _type = type or 'alert'
    if Notifications.timeout then Meteor.clearTimeout Notifications.timeout
    Session.set 'notifications', {type:type,message:message,status:"inactive"}
    Notifications.timeout = Meteor.setTimeout (->
      Session.set 'notifications', {type:type,message:message,status:"active"}    
    ), 1
    Notifications.timeout = Meteor.setTimeout (->
      Notifications.reset()   
    ), 1300
  hold: (message,type) ->
    _type = type or 'alert'
    if Notifications.timeout then Meteor.clearTimeout Notifications.timeout
    Session.set 'notifications', {type:type,message:message,status:"inactive"}
    Notifications.timeout = Meteor.setTimeout (->
      Session.set 'notifications', {type:type,message:message,status:"active"}    
    ), 1
  reset: ->
    notifications = Session.get 'notifications'
    if Notifications.timeout then Meteor.clearTimeout Notifications.timeout
    if notifications then notifications.status = 'inactive'
    Session.set 'notifications', notifications
    Notifications.timeout = Meteor.setTimeout ( ->
      Session.set 'notifications',null ), 300

Template.notifications.helpers
  notifications: ->
    Session.get 'notifications'

Template.notifications.events
  'click li': ->
    Notifications.reset()

Template.notifications.preserve ["li"]