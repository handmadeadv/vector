for i,collection of Vector.resources
  if i isnt 'accounts'
    Vector.collections[i] = new Meteor.Collection i
  else
    Vector.collections['accounts'] = Meteor.users