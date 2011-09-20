require '../helpers/spec_helper.coffee'
sentry = require '../../src/sentry.coffee'
fs = require 'fs'
_ = require 'underscore'

describe 'nap.package', ->
  
  runAsync()
  
  it 'outputs packages to the given directory', ->
    nap.package require('../stubs/assets_stub.coffee'), 'spec/fixtures/assets'
    expect(_.indexOf(fs.readdirSync('spec/fixtures/assets'), 'foo.js')).toNotEqual -1
    done()