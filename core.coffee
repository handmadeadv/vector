
instructions = "
  Missing settings.json file.<br>
  Visit <a target='_blank' href='vector.meteor.com'>vector.meteor.com</a> for full documentation,
  or use example.json located inside the package root
"


defaultResources = 
  "dashboard": {
    "roles": ["guest", "administrator", "editor"],
    "pageFields": [
      {
        "type": "welcome",
        "label": "Welcome to Vector.",
        "options": {
          "logged": instructions,
          "unlogged": instructions,
          "loggingIn": instructions
        }
      }
    ]
  }

defaultSettings = 
  "adminRoot": "/admin",
  "defaultDocumentTitleKey": "title",
  "defaultDocumentTitle": "New document",
  "defaultCollectionRoles": ["administrator"],
  "defaultDeleteWarning": "Click again to delete forever",
  "defaultNoTemplateWarning": "Template not found",
  "defaultLoginErrorWarning": "Login error",
  "defaultLoginSuccess": "Welcome",
  "documentsPerPage": 10

class _Vector

  constructor: ->

    customResources = if Meteor.settings and Meteor.settings.public and Meteor.settings.public.vectorResources then Meteor.settings.public.vectorResources else {}
    customSettings = if Meteor.settings and Meteor.settings.public and Meteor.settings.public.vectorSettings then Meteor.settings.public.vectorSettings else {}

    @resources = _.extend defaultResources, customResources
    @settings = _.extend defaultSettings, customSettings
    @collections = {}
    @subscriptionId = null
  
  checkPermissions: (userId,collectionName,writePermission) ->
    if typeof userId is 'string'
      user = Meteor.users.findOne({_id:userId})
    else
      user = userId
    userRole = if user and user.profile and user.profile.role then user.profile.role else 'guest'
    collectionRoles = Vector.resources[collectionName].roles or Vector.settings.defaultCollectionRoles
    if writePermission is true and userRole is 'guest'
      false
    else
      collectionRoles.indexOf(userRole) >= 0

Vector = new _Vector


if Meteor.isServer

  defaultPrivateSettings =
    "sendVerificationEmail": false,
    "forbidClientAccountCreation": true
    "defaultAdminRole": "administrator"
    "createDefaultUser": true

  class _VectorServer extends _Vector
    constructor: ->
      super

      customPrivateSettings = if Meteor.settings and Meteor.settings.vectorSettings then Meteor.settings.vectorSettings else {}
      @privateSettings = _.extend defaultPrivateSettings, customPrivateSettings

  Vector = new _VectorServer

