# Module dependencies
# fileUtil = require 'file'
# _ = require 'underscore'
fs = require 'fs'


@watch = (file, callback) ->
  
  # If the file is a string without wildcards, watch just that file
  if file.indexOf('/*') is -1
    fs.watchFile file, (curr, prev) ->
      console.log curr.mtime.getTime() is prev.mtime.getTime()
      console.log curr.mtime.getTime(), prev.mtime.getTime()
      console.log curr, prev
      console.log 'found change'
      callback file
    
  
# Given a file string such as /fld/**/* or /fld/*.coffee return an array of 
# file strings
# replaceWildcards = (fileStr) ->
# 
#   hasWildcards = ->
#     for file in files
#       return true if file.indexOf('/*') isnt -1
#     false
# 
#   while hasWildcards()
# 
#     for fileIndex, file of files
# 
#       # If there is a wildcard in the /**/* form of a file then remove it and
#       # splice in all files recursively in that directory
#       if file? and file.indexOf('**/*') isnt -1
#         root = file.split('**/*')[0]
#         ext = file.split('**/*')[1]
#         newFiles = []
#         fileUtil.walkSync root, (root, flds, fls) ->
#           root = (if root.charAt(root.length - 1) is '/' then root else root + '/')
#           for file in fls
#             if file.match(new RegExp ext + '$')? and _.indexOf(files, root + file) is -1
#               newFiles.push(root + file)
#         files.splice(fileIndex, 1, newFiles...)
# 
#       # If there is a wildcard in the /* form then remove it and splice in all the
#       # files one directory deep
#       else if file? and file.indexOf('/*') isnt -1
#         root = file.split('/*')[0]
#         ext = file.split('/*')[1]
#         newFiles = []
#         for file in fs.readdirSync(root)
#           if file.indexOf('.') isnt -1 and file.match(new RegExp ext + '$')? and _.indexOf(files, root + '/' + file) is -1
#             newFiles.push(root + '/' + file)
#         files.splice(fileIndex, 1, newFiles...)
# 
#   files