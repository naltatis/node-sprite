fs = require "fs"
gdlib = require "node-gd"
Seq = require "seq"
pathlib = require 'path'

Image = require './image'

class Sprite
  images = []
  
  constructor: (@name, @path, @mapper) ->
  
  load: (cb) ->
    @_readImages (err, @images) =>
      @images = images
      @mapper.map @images
      cb err
      
  url: ->
    "#{@path}/#{@name}.png"
      
  write: (cb) ->
    sprite = @_emptySprite()
    @_addImageData sprite, image for image in @images
    sprite.savePng @url(), 0, cb
  
  image: (name) ->
    result = @images.filter (i) -> i.name == name
    result[0]
  
  _width: ->
    @mapper.width
  
  _height: ->
    @mapper.height

  _emptySprite: ->
    img = gdlib.createTrueColor @_width(), @_height()
    transparent = img.colorAllocateAlpha 0, 0, 0, 127
    img.fill 0, 0, transparent
    img.colorTransparent transparent
    img.alphaBlending 0
    img.saveAlpha 1
    img
    
  _addImageData: (sprite, image) ->
    image.data.copy(
      sprite
      image.positionX # destX
      image.positionY # destY
      0 # srcX
      0 # srcY
      image.width
      image.height
    )
    
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
      files = files.filter (file) -> file.match /\.png$/
      cb err, files

  _getImage: (filename, cb) ->
    image = new Image(filename, "#{@path}/#{@name}")
    image.readDimensions (err) ->
      cb null, image

module.exports = Sprite