Template.create.events
  'click': ->
    query = {}
    collectionName = @collectionName
    query[Vector.settings.defaultDocumentTitleKey] = Vector.settings.defaultDocumentTitle
    query['created_at'] = Date.now()
    id = Vector.collections[collectionName].insert query
    Router.go('vectorEdit',{collectionName:collectionName,_id:id})


Template.accountCreate.events
    'click': ->
        context = @
        Session.set 'forms', {type: 'vectorFormAccountCreate', context: @}

Template.pagination.events
    'click button': (e,t)->
        button = e.target.innerHTML
        Session.set 'page', parseInt(button)