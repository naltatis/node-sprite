Sprite = require './lib/sprite'
mapper = require './lib/mapper'
fs = require 'fs'
Seq = require "seq"
{ EventEmitter } = require "events"

createSprite = (name, options = {}, cb = ->) ->
  options or= {}
  
  if typeof options is 'function'
    cb = options
    options = {}
    
  padding = options.padding || 2
  path = options.path || './images'

  map = new mapper.VerticalMapper padding
  sprite = new Sprite name, path, map, options.watch
  sprite.load (err) ->
    sprite.write (err) ->
      cb err, sprite
  sprite

createSprites = (options = {}, cb = ->) ->
  path = options.path || './images'

  Seq()
    .seq -> 
      fs.readdir path, @
    .flatten()
    .parFilter (dir) ->
      fs.stat "#{path}/#{dir}", (err, stat) =>
        @ err, stat.isDirectory()        
    .parMap (dir) ->
      createSprite dir, options, @
    .unflatten()
    .seq (sprites) ->
      cb null, sprites

stylus = (options = {}, cb = ->) ->
  stylus = require 'stylus'
  nodes = stylus.nodes
  result = {}
  helper = new EventEmitter()
  helper.fn = (name, image, dimensions) ->
    name = name.string
    image = image.string
    dimensions = if dimensions then dimensions.val else true
    sprite = result[name]
    throw new Error("missing sprite #{name}") if not sprite?
    item = sprite.image image
    throw new Error("missing image #{image} in sprite #{name}") if not item?

    if dimensions
      width = new nodes.Property ["width"], "#{item.width}px"
      height = new nodes.Property ["height"], "#{item.height}px"
      @closestBlock.nodes.splice @closestBlock.index+1, 0, width, height

    new nodes.Property ["background"], "url(#{sprite.url()}) #{item.positionX}px #{item.positionY}px"

  createSprites options, (err, sprites) ->
    for s in sprites
      result[s.name] = s
      s.on "update", ->
        helper.emit "update", s.name
    cb err, helper
  helper


module.exports =
  sprite: createSprite,
  sprites: createSprites
  stylus: stylus