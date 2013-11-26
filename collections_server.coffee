
_publish = (i) ->
  Vector.collections[i] = new Meteor.Collection i
  Meteor.publish "vector_#{i}", (docId) ->
    check(docId, Match.Optional(String))
    collections = []
    userId = this.userId

    if Vector.checkPermissions(userId,i)
      collections.push Vector.collections[i].find()   
      if docId
        for ii,collectionName of Vector.resources[i].children
          if userId and Vector.checkPermissions(userId,collectionName)
            query = {}
            query["#{i}_id"] = docId
            collections.push Vector.collections[collectionName].find(query)
        for ii,collectionName of Vector.resources[i].parents
          if userId and Vector.checkPermissions(userId,collectionName)
            ids = Vector.collections[i].findOne(_id:docId)["#{collectionName}_id"]
            if ids
              collections.push Vector.collections[collectionName].find({_id:{$in:ids}})

    collections

  Vector.collections[i].allow
    insert: (userId) ->
      Vector.checkPermissions(userId,i,true)
    update:(userId) ->
      Vector.checkPermissions(userId,i,true)
    remove:(userId) ->
      Vector.checkPermissions(userId,i,true)


for i,collection of Vector.resources
  if i isnt 'accounts'
    _publish i

  else
    Vector.collections['accounts'] = Meteor.users
    Meteor.publish 'vector_accounts', (docId)->
      check(docId, Match.Optional(String))
      fields = {username:1,profile:1,emails:1}
      userId = this.userId
      user = Meteor.users.findOne({_id:userId})
      collections = []

      if userId and Vector.checkPermissions(user._id,'accounts')
        collections.push Meteor.users.find({},fields)
      else if userId
        collections.push Meteor.users.find({_id:this.userId},fields)

      for ii,collectionName of Vector.resources['accounts'].children
        do ->
          if Vector.checkPermissions(userId,collectionName)
            query = {}
            query["accounts_id"] = userId
            collections.push Vector.collections[collectionName].find(query)
      for ii,collectionName of Vector.resources['accounts'].parents
        do ->
          if Vector.checkPermissions(userId,collectionName)
            ids = Vector.collections[i].findOne(_id:docId)["#{collectionName}_id"]
            if ids
              collections.push Vector.collections[collectionName].find({_id:{$in:ids}})
              
      collections

    Meteor.users.allow
      insert: (userId,doc) ->
        if Vector.checkPermissions(userId,'user') then true
        else if userId then doc._id is userId
      update: (userId,doc) ->
        if Vector.checkPermissions(userId,'user') then true
        else if userId then doc._id is userId
      remove: (userId,doc) ->
        if Vector.checkPermissions(userId,'user') then true
        else if userId then doc._id is userId

Accounts.config
  sendVerificationEmail: Vector.privateSettings.sendVerificationEmail
  forbidClientAccountCreation: Vector.privateSettings.forbidClientAccountCreation

_users = Meteor.users.find({"profile.role":Vector.privateSettings.defaultAdminRole}).count()
if _users is 0 and Vector.privateSettings.createDefaultUser is true
  Accounts.createUser
    email: "super@user.com"
    password: "super"
    profile:
      role: Vector.privateSettings.defaultAdminRole