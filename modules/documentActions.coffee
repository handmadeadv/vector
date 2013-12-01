Template.delete.events
  'click': (e,t)->
    button = $(t.find("button"))
    if button.hasClass('active')
      id = @data._id
      model = Vector.resources[@collectionName]
      Vector.collections[@collectionName].remove {_id:id}
    else
      Vector.notifications.send @field.options or Vector.settings.defaultDeleteWarning
      $(t.find("button")).addClass 'active'

Template.duplicate.events
  'click': ->
    model = Vector.resources[@collectionName].documentFields
    titleKey = Vector.settings.defaultDocumentTitleKey
    collectionName = @collectionName
    query = {}
    for i,field of model
      query[field.key] = @data[field.key]
    query[titleKey] = "(copy) #{query[titleKey]}"
    query['created_at'] = Date.now()
    id = Vector.collections[@collectionName].insert query
    Router.go('vectorEdit',{collectionName:collectionName,_id:id})
    Session.set 'page', 1