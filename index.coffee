Sprite = require './lib/sprite'
mapper = require './lib/mapper'

module.exports =
  create: (name, options, cb) ->
    options or= {}
    
    if typeof options == 'function'
      cb = options
      options = {}
      
    padding = options.padding || 2
    path = options.path || './images'
      
    mapper = new mapper.VerticalMapper padding
    sprite = new Sprite name, path, mapper
    sprite.load (err) ->
      sprite.write (err) ->
        cb err, sprite