stylus = require 'stylus'
node = stylus.nodes
sprite = require '../'
str = require('fs').readFileSync(__dirname + '/sprite.styl', 'utf8')

sprite.create 'global', {path: './images', padding: 2}, (err, global) ->
  globalSprite = (image) ->
    item = global.image image.string
    console.log new nodes.String("background: url(#{global.url()}) #{item.positionX}px #{item.positionY}px")

  stylus(str)
    .set('filename', __dirname + '/sprite.styl')
    .define('sprite', globalSprite)
    .render (err, css) ->
      console.log css