adminRoot = Vector.settings.adminRoot


Meteor.startup ->
  # init application state: current page
  Session.setDefault 'page', 1
  # init application state: current collection name
  Session.setDefault 'colletionName', null

Router.map ->

  @route 'vectorIndex',
    path: "#{adminRoot}"
    before: ->
      for i,m of Vector.resources
        Router.go Router.path('vectorCollection',{collectionName:i})
        break

  @route 'vectorCollection',
    path: "#{adminRoot}/:collectionName"
    layoutTemplate: 'vectorLayout'
    before: ->
      unless Session.equals 'collectionName', @params.collectionName
        Session.set 'collectionName', @params.collectionName
        Session.set 'page', 1
    waitOn: ->
      Vector.subscriptionId = Meteor.subscribe "vector_" + @params.collectionName
    data: ->
      page = Session.get 'page'
      docsPerPage = Vector.settings.documentsPerPage
      model = Vector.resources[@params.collectionName]
      collectionName = @params.collectionName
      pageFields: if model.pageFields then model.pageFields else null
      collectionFields: if model.collectionFields then model.collectionFields else null
      collectionActions: if model.collectionActions then model.collectionActions else null
      collection: Vector.collections[collectionName].find({},
        sort: {created_at: -1},
        skip: (page - 1) * docsPerPage,
        limit: docsPerPage).fetch()
      collectionCount: Vector.collections[collectionName].find().count()
      documentFields: if model.documentFields then model.documentFields else null
      documentActions: if model.documentActions then model.documentActions else null
      collectionName: collectionName
      page: page
    template: 'vectorEdit'

  @route 'vectorEdit',
    path: "#{adminRoot}/:collectionName/:_id"
    layoutTemplate: 'vectorLayout'
    waitOn: ->
      Vector.subscriptionId = Meteor.subscribe "vector_" + @params.collectionName, @params._id
    before: ->
      unless Session.equals 'collectionName', @params.collectionName
        Session.set 'collectionName', @params.collectionName
        Session.set 'page', 1
      if this.ready()
        _id = @params._id
        collectionName = @params.collectionName
        unless Vector.collections[collectionName].findOne({_id:_id})
          Router.go Router.path('vectorCollection',{collectionName:collectionName})
    data: ->
      _id = @params._id
      page = Session.get 'page'
      docsPerPage = Vector.settings.documentsPerPage
      model = Vector.resources[@params.collectionName]
      collectionName = @params.collectionName
      pageFields: if model.pageFields then model.pageFields else null
      collectionFields: if model.collectionFields then model.collectionFields else null 
      collectionActions: if model.collectionActions then model.collectionActions else null
      collection: Vector.collections[collectionName].find({},
        sort: {created_at: -1},
        skip: (page - 1) * docsPerPage,
        limit: docsPerPage).fetch()
      collectionCount: Vector.collections[collectionName].find().count()
      documentFields: if model.documentFields then model.documentFields else null
      documentActions: if model.documentActions then model.documentActions else null
      document: Vector.collections[collectionName].findOne({_id:_id})
      collectionName: collectionName
      page: page
    template: 'vectorEdit'

  @route 'vectorCollectionRelated',
    path: "#{adminRoot}/:collectionName/:_id/:relatedCollectionName"
    layoutTemplate: 'vectorLayout'
    waitOn: ->
      Vector.subscriptionId = Meteor.subscribe "vector_" + @params.collectionName, @params._id
    before: ->
      unless Session.equals 'collectionName', @params.collectionName
        Session.set 'collectionName', @params.collectionName
        Session.set 'page', 1
      if this.ready()
        _id = @params._id
        collectionName = @params.collectionName
        unless Vector.collections[collectionName].findOne({_id:_id})
          Router.go Router.path('vectorCollection',{collectionName:collectionName})
    data: ->
      page = Session.get 'page'
      docsPerPage = Vector.settings.documentsPerPage
      _id = @params._id
      model = Vector.resources[@params.collectionName]
      collectionName = @params.relatedCollectionName
      pageFields: if model.pageFields then model.pageFields else null
      collectionFields: if model.collectionFields then model.collectionFields else null 
      collectionActions: if model.collectionActions then model.collectionActions else null
      collection: Vector.collections[collectionName].find({},
        sort: {created_at: -1},
        skip: (page - 1) * docsPerPage,
        limit: docsPerPage).fetch()
      collectionCount: Vector.collections[collectionName].find().count()
      documentFields: if model.documentFields then model.documentFields else null
      documentActions: if model.documentActions then model.documentActions else null
      collectionName: collectionName
      page: page
    template: 'vectorEdit'