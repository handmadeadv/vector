class Notifications
  @timeout = null

  send: (message,type) ->
    _type = type or 'alert'
    if @timeout then Meteor.clearTimeout @timeout
    Session.set 'notifications', {type:type,message:message,status:"inactive"}
    @timeout = Meteor.setTimeout (=>
      Session.set 'notifications', {type:type,message:message,status:"active"}    
    ), 1
    @timeout = Meteor.setTimeout (=>
      @reset()   
    ), 1300
  hold: (message,type) ->
    _type = type or 'alert'
    if @timeout then Meteor.clearTimeout @timeout
    Session.set 'notifications', {type:type,message:message,status:"inactive"}
    @timeout = Meteor.setTimeout (=>
      Session.set 'notifications', {type:type,message:message,status:"active"}    
    ), 1
  reset: ->
    notifications = Session.get 'notifications'
    if @timeout then Meteor.clearTimeout @timeout
    if notifications then notifications.status = 'inactive'
    Session.set 'notifications', notifications
    Notifications.timeout = Meteor.setTimeout ( =>
      Session.set 'notifications',null ), 300

Vector.notifications = new Notifications()

Template.notifications.helpers
  notifications: ->
    Session.get 'notifications'

Template.notifications.events
  'click li': ->
    Notifications.reset()

Template.notifications.preserve ["li"]