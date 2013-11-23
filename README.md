# Vector
Vector allow the developer to create and extend administration panels for end users in minutes.

## Use now

<pre>
mrt add bootstrap-3
mrt add iron-router
mrt add vector
meteor remove autopublish
meteor remove insecure
meteor --settings settings.json (use the file inside /example)
go to /admin
user: super@user.com, password: super
--> delete content from the body and use iron-router layouts for your main content
</pre>

## Full documentation

<a href="http://vector.meteor.com">vector.meteor.com</a>

## Features
- Auto generated admin panel just using settings.json
- Roles and accounts management
- Easy relationships beween collections
- Largely customizable with components
- Easy extendable; modules are plain Meteor templates
- Separation between setup and content management; end users are limited to what the developer has set

## Roadmap

- 0.1 (completed) preview mode; fully functional but untested
- 0.2 (current) better core and more modularity
- 0.3 production ready

## License

The MIT License (MIT)

Copyright (c) 2013 Handmade and Davide Dal Colle

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:  

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.  

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE