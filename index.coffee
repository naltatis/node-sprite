Sprite = require './lib/sprite'
mapper = require './lib/mapper'
stylus = require 'stylus'
nodes = stylus.nodes
fs = require 'fs'
Seq = require "seq"

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
  result = {}
  helper = (name, image) ->
    name = name.val
    image = image.val
    s = result[name]
    return new nodes.String("missing sprite #{name}") if not s?
    item = s.image image
    return new nodes.String("missing image #{image} in sprite #{name}") if not item?
    new nodes.String("background: url(#{s.url()}) #{item.positionX}px #{item.positionY}px")

  createSprites options, (err, sprites) ->
    result[s.name] = s for s in sprites
    cb err, helper
  helper


module.exports =
  sprite: createSprite,
  sprites: createSprites
  stylus: stylus