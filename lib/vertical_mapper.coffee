class VerticalMapper
  constructor: (@padding) ->
  map: (images) ->
    @width = @height = 0

    for image in images
      image.positionX = 0
      image.positionY = @height
      @height += image.height + @padding
      @width = image.width if image.width > @width
      
    @height -= @padding

module.exports = VerticalMapper