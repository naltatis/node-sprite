im = require "imagemagick"

class Image
  positionX: null
  positionY: null
  constructor: (@filename, @path) ->
    @name = @filename.replace /\.png$/, ''
  readDimensions: (cb) ->
    im.identify @file(), (err, img) =>
      @width = img.width
      @height = img.height
      cb(err)
  file: ->
    "#{@path}/#{@filename}"

module.exports = Image