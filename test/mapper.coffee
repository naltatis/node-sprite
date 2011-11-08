Sprite = require '../lib/sprite'
VerticalMapper = require('../lib/mapper').VerticalMapper
HorizontalMapper = require('../lib/mapper').HorizontalMapper

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
      
      # checking sprite dimensions
      assert.equal 800, mapper.width
      assert.equal 1320, mapper.height
      
      # checking area
      assert.equal 800*1320, mapper.area()
      
  testHorizontalMapper: (beforeExit, assert) ->
    mapper = new HorizontalMapper(10)
    sprite = new Sprite 'global', path, mapper
    sprite.load ->
      images = sprite.images
      mapper.map images

      # checking y positions
      assert.equal 0, images[0].positionX
      assert.equal 110, images[1].positionX
      assert.equal 220, images[2].positionX
      assert.equal 430, images[3].positionX
      assert.equal 690, images[4].positionX
      assert.equal 1050, images[5].positionX
      assert.equal 1110, images[6].positionX
      assert.equal 1170, images[7].positionX

      # checking x positions
      assert.equal 0, image.positionY for image in images

      # checking sprite dimensions
      assert.equal 1970, mapper.width
      assert.equal 300, mapper.height

      # checking area
      assert.equal 1970*300, mapper.area()