# Module dependencies
fileUtil = require 'file'
_ = require 'underscore'
fs = require 'fs'
exec = require('child_process').exec
path = require 'path'

# sentry.watch(file, [task], callback)
# If passed a task callback is passed (err, stdout, stderr)
# If task is ommitted then callback is passed (filename)
@watch = (file, task, callback) ->
  
  callback = task if _.isFunction task
  
  # Recursively find anything that matches the regex
  if _.isRegExp file
    # fileUtil.walkSync root, (root, flds, fls) ->
    #   root = (if root.charAt(root.length - 1) is '/' then root else root + '/')
    #   for file in fls
    #     if file.match(new RegExp ext + '$')? and _.indexOf(files, root + file) is -1
    #       files.push(root + file)
  
  # If the file is a string without wildcards, watch just that file
  else if file.indexOf('/*') isnt -1
    files = findWildcardFiles file
    watchFile(file, task, callback) for file in files
    
  # Get the files we want to catch with the wildcards
  else
    throw new Error("SENTRY: File '#{file}' does not exist!") unless path.existsSync file
    watchFile(file, task, callback)
      
# Watch a file for changes and execute a callback or child process
watchFile = (file, task, callback) ->
  fs.watchFile file, (curr, prev) ->
    return if curr.size is prev.size and curr.mtime.getTime() is prev.mtime.getTime() 
    if _.isString task
      exec 'cake stub', (err, stdout, stderr) -> 
        callback(err, stdout, stderr)
    else
      callback file
  
# Given a file string such as /fld/**/* or /fld/*.coffee return an array of file strings
findWildcardFiles = (file) ->
  
  files = []
  
  # If there is a wildcard in the /**/* form of a file then remove it and
  # splice in all files recursively in that directory
  if file? and file.indexOf('**/*') isnt -1
    root = file.split('**/*')[0]
    ext = file.split('**/*')[1]
    fileUtil.walkSync root, (root, flds, fls) ->
      root = (if root.charAt(root.length - 1) is '/' then root else root + '/')
      for file in fls
        if file.match(new RegExp ext + '$')? and _.indexOf(files, root + file) is -1
          files.push(root + file)

  # If there is a wildcard in the /* form then remove it and splice in all the
  # files one directory deep
  else if file? and file.indexOf('/*') isnt -1
    root = file.split('/*')[0]
    ext = file.split('/*')[1]
    for file in fs.readdirSync(root)
      if file.indexOf('.') isnt -1 and file.match(new RegExp ext + '$')? and _.indexOf(files, root + '/' + file) is -1
        files.push(root + '/' + file)
        
  files