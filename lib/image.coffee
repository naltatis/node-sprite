gdlib = require "node-gd"

class Image
  positionX: null
  positionY: null
  data: null
  constructor: (@filename, @path) ->
    @name = @filename.replace /\.png$/, ''
  readDimensions: (cb) ->
    path = "#{@path}/#{@filename}"
    gdlib.openPng path, (err, img) =>
      @data = img
      @width = img.width
      @height = img.height
      cb err

module.exports = Image