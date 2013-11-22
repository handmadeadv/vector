Template.vectorFormPasswordChange.events
  'submit form': (e,t) ->
    e.preventDefault()
    oldPassword = t.find("#vectorFormPasswordChange_old").value
    newPassword = t.find("#vectorFormPasswordChange_new").value
    if oldPassword and newPassword
      Accounts.changePassword oldPassword, newPassword, (error,result) ->
        if error
          Notifications.send 'Wrong password'
        else
          Notifications.send 'success'
          Session.set 'forms', null
    else
      Notifications.send 'Please fill all the fields'

Template.vectorFormAccountCreate.events
  'submit form': (e,t) ->
    e.preventDefault()
    email = t.find("#vectorFormAccountCreate_email").value
    password = t.find("#vectorFormAccountCreate_password").value
    role = t.find("#vectorFormAccountCreate_role").value
    profile = {role:role}
    if email and password
      Meteor.call 'vectorCreateUser', email,password,profile
      Session.set 'forms'. null

Template.vectorFormChildren.events
  'submit form': (e,t) ->
    e.preventDefault()
    options = t.find("select").options
    childrenIds = []
    parentId = @data._id
    for i,o of options
      do (o)->
        if o.selected
          childrenIds.push o.getAttribute 'data-id'
    if @action is 'add'
      if childrenIds.length > 0
        Meteor.call 'addChildren', @field.key, @collectionName, childrenIds, parentId, ->
          Session.set 'forms', null
    else if @action is 'remove'
      if childrenIds.length > 0      
        Meteor.call 'removeChildren', @field.key, @collectionName, childrenIds, parentId, ->
          Session.set 'forms', null

Template.vectorFormParents.events
  'submit form': (e,t) ->
    e.preventDefault()
    options = t.find("select").options
    parentIds = []
    childrenId = @data._id
    collectionName = @collectionName
    for i,o of options
      do (o)->
        if o.selected
          parentIds.push o.getAttribute 'data-id'
    if @action is 'add'
      if parentIds.length > 0
        Meteor.call 'addParents', @collectionName, @field.key, childrenId, parentIds, (er,r) ->
          newDoc = Vector.collections[collectionName].findOne({_id:childrenId})
          oldData = Router.getData()
          oldData.data = newDoc
          Router.setData oldData
          Vector.subscriptionId.stop()
          Vector.subscriptionId = Meteor.subscribe "#{collectionName}_id", childrenId
          Session.set 'forms', null
    else if @action is 'remove'
      if parentIds.length > 0   
        Meteor.call 'removeParents', @collectionName, @field.key, childrenId, parentIds, ->
          newDoc = Vector.collections[collectionName].findOne({_id:childrenId})
          oldData = Router.getData()
          oldData.data = newDoc
          Router.setData oldData
          Vector.subscriptionId.stop()
          Vector.subscriptionId = Meteor.subscribe "#{collectionName}_id", childrenId
          Session.set 'forms', null