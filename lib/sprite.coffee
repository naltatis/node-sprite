fs = require "fs"
im = require "imagemagick"
watch = require 'watch'
Seq = require "seq"
pathlib = require 'path'
{ EventEmitter } = require "events"

Image = require './image'

class Sprite extends EventEmitter
  images = []
  
  constructor: (@name, @path, @mapper, @watch = false) ->

  reload: ->
    @_readImages (err, @images) =>
      @images = images
      @mapper.map @images
      @emit "update"
  
  load: (cb = ->) ->
    @_readImages (err, @images) =>
      @images = images
      @mapper.map @images
      @_watch()
      cb err

  url: ->
    "#{@path}/#{@name}.png"
      
  write: (cb) ->
    commands = @_emptySprite()
    @_addImageData(commands, image) for image in @images
    commands.push @url()
    im.convert commands, cb
  
  image: (name) ->
    result = @images.filter (i) -> i.name == name
    result[0]
  
  _watch: ->
    return unless @watch
    watch.createMonitor "#{@path}/#{@name}/", interval: 500, (m) =>
      m.on "created", => @reload()
      m.on "changed", => @reload()
      m.on "removed", => @reload()

  _width: ->
    @mapper.width
  
  _height: ->
    @mapper.height

  _emptySprite: ->
    ["-size", "#{@_width()}x#{@_height()}", "xc:none"]
    
  _addImageData: (commands, image) ->
    commands.push image.file(), "-geometry", "+#{image.positionX}+#{image.positionY}", "-composite"
    
  _readImages: (cb) ->
    Seq()
      .seq_ (next) => 
        @_getFiles next
      .flatten()
      .parMap_ (next, filename) =>
        @_getImage filename, next
      .unflatten()
      .seq_ (next, images) =>
        cb null, images
  
  _getFiles: (cb) ->
    fs.readdir "#{@path}/#{@name}", (err, files) ->
      files = files.filter (file) -> file.match /\.(png|gif|jpg|jpeg)$/
      cb err, files

  _getImage: (filename, cb) ->
    image = new Image(filename, "#{@path}/#{@name}")
    image.readDimensions (err) ->
      cb null, image

module.exports = Sprite