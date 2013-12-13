
# main admin navigation
Handlebars.registerHelper 'navigation', ->
  page = Session.get 'page'
  count = Router.getData().collectionCount
  documentsPerPage = Vector.settings.documentsPerPage
  pageCount = Math.ceil  count / documentsPerPage
  pages = []
  if pageCount >= 2
    for i in [1..pageCount] by 1
      pages.push
        index: i
        active: if i is page then true else false
  pages

# render a single field for collections and documents
# pass the correct context
Handlebars.registerHelper 'renderField', (field,data,collectionName) ->
    context =
      data: data
      field: field
      collectionName: collectionName
    if Template[field.type]
      new Handlebars.SafeString(Template[field.type](context))
    else
      "#{Vector.settings.defaultNoTemplateWarning}: #{field.type}"

# the raw property data
# unfiltered fields such as inputs or textareas use this
Handlebars.registerHelper 'plainValue', () ->
  if @field and @field.key and @data
    dataRecursive(@data, @field.key)

# if key is a dotted string (profile.name) then this method will traverse the data object
# to return data.profile.name
dataRecursive = (data, key) ->
  for keyElement in key.split('.')
    data = data[keyElement] if data
  data

# check if the document is active
Handlebars.registerHelper 'activeDocumentIs', (_id) ->
  if Router.getData() and Router.getData().document
    Router.getData().document._id is _id
  else
    false

# check if the collection is active
Handlebars.registerHelper 'activeCollectionIs', (collectionName) ->
  if Router.getData() and Router.getData().collectionName
    Router.getData().collectionName is collectionName
  else
    false

# list of collections
Handlebars.registerHelper 'collectionList', ->
  list = []
  for i, resource of Vector.resources
    if Vector.checkPermissions(Meteor.user(),i)
      list.push
        label: resource.label or ( i.charAt(0).toUpperCase() + i.slice(1) )
        url: "#{Vector.settings.adminRoot}/#{i}"
        name: i
  list

# general settings
Handlebars.registerHelper 'settings', ->
  Vector.settings


Meteor.startup ->
  Session.set 'forms', null

Template.vectorNav.events
  'click #vectorNavSide_logout': ->
    Meteor.logout()
    Router.go "#{Vector.settings.adminRoot}/"

Template.currentForm.helpers
  form: ->
    data = Session.get 'forms'
    if data
      if data.type
        new Handlebars.SafeString(Template[data.type](data.context))
      else
        new Handlebars.SafeString(Template[data]())

Template.currentForm.events
  'click .vectorFormCancel': (e) ->
    e.preventDefault()
    Session.set 'forms', null



