stylus = require 'stylus'
node = stylus.nodes
sprite = require('../')
str = require('fs').readFileSync(__dirname + '/sprite.styl', 'utf8')

###
stylus(str)
  .set('filename', __dirname + '/sprite.styl')
  .define('sprite', sprite.stylus())
  .render (err, css) ->
    console.log err, css

###

sprite.stylus {path: "./images"}, (err, stylusSprite) ->
  stylus(str)
    .set('filename', __dirname + '/sprite.styl')
    .define('sprite', stylusSprite)
    .render (err, css) ->
      console.log css