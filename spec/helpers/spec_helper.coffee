# Run an entire suite aynchronously
_done = false
@done = -> _done = true
@runAsync = ->
  beforeEach -> _done = false
  afterEach -> waitsFor -> _done
  
global.__rootdir = __dirname.split('/').slice(0, -2).join('/')