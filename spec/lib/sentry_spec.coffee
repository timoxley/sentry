require '../helpers/spec_helper.coffee'
sentry = require '../../src/sentry.coffee'
fs = require 'fs'

describe 'sentry.watch', ->
  
  describe 'given a relative file string', ->
    
    runAsync()
    
    it 'runs a function when the file is changed', ->
      fs.writeFileSync __rootdir + '/spec/fixtures/foo.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/foo.js', ->
        expect(2 + 2).toEqual 4
        done()
      setTimeout (-> fs.writeFileSync __rootdir + '/spec/fixtures/foo.js', 'Hello World'), 100