Template.delete.events
  'click': (e,t)->
    button = $(t.find("button"))
    if button.hasClass('active')
      id = @data._id
      model = Vector.resources[@collectionName]
      # for i,field of model.documentFields
      #   if field.type is 'gallery'
      #     gallery = @data[field.key]
      #     for ii,image of gallery
      #       Meteor.call 'remove', image.public_id
      Vector.collections[@collectionName].remove {_id:id}
    else
      Notifications.send @field.options or Vector.settings.defaultDeleteWarning
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