# Sentry

**sentry is currently in an early alpha development stage. Please feel free to take a look around the source code to get an idea of where the project is going.**

Sentry is a simple node tool to watch for file changes (using a path, wildcards, or a regex) and execute a function or shell command.

## Installation

    $ npm install sentry

## Example

````coffeescript
sentry = require 'sentry'

# Watch changes relative in file.js
sentry.watch 'file.js', (file) -> console.log 'A change has been made in #{file}'

# Watch changes one directory deep
sentry.watch 'fld/*.coffee', ->

# Watch changes recursively on any files 
sentry.watch 'fld/**/*', ->

# Watch files recursively that match a regex
sentry.watch /regex/, ->

# If you pass a string instead of a function it'll execute that shell command
sentry.watch 'file.coffee', 'coffee -c'
````
   
## To run tests

nap uses [Jasmine-node](https://github.com/mhevery/jasmine-node) for testing. Simply run the jasmine-node command with the coffeescript flag

    jasmine-node spec --coffee