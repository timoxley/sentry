fileUtil = require 'file'
_ = require 'underscore'
fs = require 'fs'
exec = require('child_process').exec
path = require 'path'

# Watch for changes on a file using a file path or wildcards
# If passed a task callback is passed (err, stdout, stderr)
# If task is ommitted then callback is passed (filename)
# 
# @param {String} filename File path to watch, optionally pass /* or /**/* wildcards
# @param {String} [task] Optionally run a child process
# @param {Function} callback

@watch = (filename, task, callback) =>
  
  callback = task if _.isFunction task
  
  # If the file is a string without wildcards, watch just that file
  if filename.indexOf('/*') isnt -1
    files = @findWildcards filename
    watchFile file, task, callback for file in files
    
  # Get the files we want to catch with the wildcards
  else
    throw new Error("SENTRY: File '#{filename}' does not exist!") unless path.existsSync filename
    watchFile filename, task, callback

# Watch for file changes recursively in a directory that match a regex
# If passed a task callback is passed (err, stdout, stderr)
# If task is ommitted then callback is passed (filename)
# 
# @param {String} dir Root directory to search in
# @param {RegExp} regex
# @param {String} [task] Optionally run a child process
# @param {Function} callback

@watchRegExp = (dir, regex, task, callback) ->
  
  callback = task if _.isFunction task
  
  # Recursively find anything that matches the regex
  dir = path.resolve(path.dirname(module.parent.filename), dir)
  files = []
  fileUtil.walkSync dir, (rt, flds, fls) ->
    for fl in fls
      flPath = rt + '/' + fl
      files.push(flPath) if flPath.match regex
  files
  
  # Watch the matches files
  watchFile(file, task, callback) for file in files
  
# Watch a file for changes and execute a callback or child process.
# 
# @param {String} filename
# @param {String} [task]
# @param {Function} callback

watchFile = (filename, task, callback) ->
  fs.watchFile filename, (curr, prev) ->
    return if curr.size is prev.size and curr.mtime.getTime() is prev.mtime.getTime() 
    if _.isString task
      exec task, (err, stdout, stderr) ->
        console.log stdout
        console.log err if err?
        callback(err, stdout, stderr) if callback?
    else
      callback filename
  
# Given a filename such as /fld/**/* return all recursive files
# or given a filename such as /fld/* return all files one directory deep.
# Limit by extension via /fld/**/*.coffee
# 
# @param {String} filename
# @return {Array} An array of file path strings

@findWildcards = (filename) ->
  
  files = []
  
  # If there is a wildcard in the /**/* form of a file then remove it and
  # splice in all files recursively in that directory
  if filename? and filename.indexOf('**/*') isnt -1
    root = filename.split('**/*')[0]
    ext = filename.split('**/*')[1]
    fileUtil.walkSync root, (root, flds, fls) ->
      root = (if root.charAt(root.length - 1) is '/' then root else root + '/')
      for file in fls
        if file.match(new RegExp ext + '$')? and _.indexOf(files, root + file) is -1
          files.push(root + file)

  # If there is a wildcard in the /* form then remove it and splice in all the
  # files one directory deep
  else if filename? and filename.indexOf('/*') isnt -1
    root = filename.split('/*')[0]
    ext = filename.split('/*')[1]
    for file in fs.readdirSync(root)
      if file.indexOf('.') isnt -1 and file.match(new RegExp ext + '$')? and _.indexOf(files, root + '/' + file) is -1
        files.push(root + '/' + file)
        
  files