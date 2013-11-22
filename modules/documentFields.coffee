
Template.text.events
  'keyup': (e,t) ->
    id = @data._id
    query = {}
    query[@field.key] = e.target.value
    Vector.collections[@collectionName].update {_id:id},{$set:query}  

Template.textarea.events
  'keyup': (e,t) ->
    id = @data._id
    query = {}
    query[@field.key] = e.target.value
    Vector.collections[@collectionName].update {_id:id},{$set:query}

Template.accountPassword.events
  'click .accountPassword_change': ->
    Session.set 'forms', 'vectorFormPasswordChange'

Template.children.helpers
  childrenData: ->
    unless @field.key is 'accounts'
      Vector.collections[@field.key].find().count()
    else
      query = {}
      query["#{@collectionName}_id"] = @data._id
      Vector.collections[@field.key].find(query).count()

Template.children.events
  'click .childrenAdd': ->
    documents = []
    data = @
    Meteor.call 'getUnrelated', @field.key, data.collectionName, data.data._id, {title:1,_id:1,emails:1}, 'children', (e,r) ->
      if r
        documents = r
        context =
          data: data.data
          field: data.field
          collectionName: data.collectionName
          related: documents
          relation: 'children'
          action: 'add'
        Session.set("forms",{type:'vectorFormChildren',context:context})
  'click .childrenRemove': ->
    unless @field.key is 'accounts'
      documents = Vector.collections[@field.key].find().fetch()
    else
      query = {}
      query["#{@collectionName}_id"] = @data._id
      documents = Vector.collections[@field.key].find(query).fetch()
      console.log documents
    data = @
    context =
      data: data.data
      field: data.field
      collectionName: data.collectionName
      related: documents
      relation: 'children'
      action: 'remove'
    Session.set("forms",{type:'vectorFormChildren',context:context})
    'click .childrenRemove': ->
      alert 'remove'

Template.parents.helpers
  parentsData: (e,t) ->
    unless @field.key is 'accounts'
      Vector.collections[@field.key].find().count()
    else
      query = {}
      parentIds = Vector.collections[@collectionName].findOne(@data._id)["#{@field.key}_id"] or []
      query["_id"] = {$in:parentIds}
      Vector.collections[@field.key].find(query).count()

Template.parents.events
  'click .parentsAdd': ->
    documents = []
    data = @
    ids = data.data["#{@field.key}_id"] or []
    Meteor.call 'getUnrelated', data.collectionName, @field.key, ids, {title:1,_id:1,emails:1}, 'parents', (e,r) ->
      if r
        documents = r
        context =
          data: data.data
          field: data.field
          collectionName: data.collectionName
          related: documents
          action: 'add'
        Session.set("forms",{type:'vectorFormParents',context:context})
  'click .parentsRemove': ->
    data = @
    ids = data.data.articles_id or []
    unless @field.key is 'accounts'
      documents = Vector.collections[@field.key].find().fetch()
    else
      query = {}
      parentIds = Vector.collections[@collectionName].findOne(@data._id)["#{@field.key}_id"] or []
      query["_id"] = {$in:parentIds}
      documents = Vector.collections[@field.key].find(query).fetch()
    context =
      data: data.data
      field: data.field
      collectionName: data.collectionName
      related: documents
      action: 'remove'
    Session.set("forms",{type:'vectorFormParents',context:context})