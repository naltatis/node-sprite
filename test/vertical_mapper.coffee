Sprite = require '../lib/sprite'
VerticalMapper = require '../lib/vertical_mapper'

path = './test/images'

module.exports =
  testVerticalMapper: (beforeExit, assert) ->
    mapper = new VerticalMapper(10)
    sprite = new Sprite 'global', path, mapper
    sprite.load ->
      images = sprite.images
      mapper.map images
      
      # checking y positions
      assert.equal 0, images[0].positionY
      assert.equal 110, images[1].positionY
      assert.equal 420, images[2].positionY
      assert.equal 630, images[3].positionY
      assert.equal 940, images[4].positionY
      assert.equal 1100, images[5].positionY
      assert.equal 1210, images[6].positionY
      assert.equal 1270, images[7].positionY
      
      # checking x positions
      assert.equal 0, image.positionX for image in images
      
      #checking sprite dimensions
      assert.equal 800, mapper.width
      assert.equal 1320, mapper.height