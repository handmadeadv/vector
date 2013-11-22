Meteor.methods

  # create a user
  vectorCreateUser: (email,password,profile) ->
    Accounts.createUser
      email: email
      password: password
      profile: profile

  # get documents
  # used to get data not published/related (i.e. a list of document to add as a relationship)    
  getUnrelated: (childrenCollectionName,parentCollectionName,parentIds,fields,relation) ->
    if relation is 'children'
      query = {}
      query["#{parentCollectionName}_id"] = {$ne:parentIds}
      Vector.collections[childrenCollectionName].find(query,fields:fields).fetch()
    else if relation is 'parents'
      query = {}
      query["_id"] = {$nin:parentIds}
      Vector.collections[parentCollectionName].find(query,fields:fields).fetch()

  getRelated: (childrenCollectionName,parentCollectionName,ids,fields,relation) ->
    if relation is 'children'
      query = {}
      query["#{parentCollectionName}_id"] = ids
      Vector.collections[childrenCollectionName].find(query,fields:fields).fetch()
    else if relation is 'parents'
      query = {}
      parentIds = Vector.collections[childrenCollectionName].findOne(ids)["#{parentCollectionName}_id"]
      query["_id"] = {$in:parentIds}
      Vector.collections[parentCollectionName].find(query,fields:fields).fetch()

  addChildren: (childrenCollectionName,parentCollectionName,childrenIds,parentId) ->
    query = {}
    query["#{parentCollectionName}_id"] = parentId
    Vector.collections[childrenCollectionName].update({_id: {$in:childrenIds}},{$push:query},{multi:true});

  removeChildren: (childrenCollectionName,parentCollectionName,childrenIds,parentId) ->
    query = {}
    query["#{parentCollectionName}_id"] = parentId
    Vector.collections[childrenCollectionName].update({_id: {$in:childrenIds}},{$pull:query},{multi:true})

  addParents: (childrenCollectionName,parentCollectionName,childrenId,parentIds) ->
    query = {}
    query["#{parentCollectionName}_id"] = {$each:parentIds}
    id = Vector.collections[childrenCollectionName].update(childrenId,{$push:query})

  removeParents: (childrenCollectionName,parentCollectionName,childrenId,parentIds) -> 
    query = {}
    query["#{parentCollectionName}_id"] = parentIds
    Vector.collections[childrenCollectionName].update(childrenId,{$pullAll:query})
