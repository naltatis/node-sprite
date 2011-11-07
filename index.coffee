Sprite = require './lib/sprite'
VerticalMapper = require './lib/vertical_mapper'

module.exports =
  create: (name, options, cb) ->
    options or= {}
    
    if typeof options == 'function'
      cb = options
      options = {}
      
    padding = options.padding || 2
    path = options.path || './images'
      
    mapper = new VerticalMapper padding
    sprite = new Sprite name, path, mapper
    sprite.load (err) ->
      sprite.write (err) ->
        cb err, sprite