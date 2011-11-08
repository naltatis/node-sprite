Sprite = require '../lib/sprite'
Image = require '../lib/image'
VerticalMapper = require('../lib/mapper').VerticalMapper
HorizontalMapper = require('../lib/mapper').HorizontalMapper

path = './test/images'

mapper = new VerticalMapper(10)

module.exports =
  testSpriteLoading: (beforeExit, assert) ->
    sprite = new Sprite 'global', path, mapper
    sprite.load ->
      assert.equal 8, sprite.images.length 
  testWritingOutput: (beforeExit, assert) ->
    sprite = new Sprite 'global', path, mapper
    sprite.load ->
      sprite.write ->
        assert.ok true
  testImageInfo: (beforeExit, assert) ->
    sprite = new Sprite 'global', path, mapper
    sprite.load ->
      assert.equal 50, sprite.image('50x50').width
      assert.equal 150, sprite.image('350x150').height
      assert.equal 0, sprite.image('100x300').positionX
      assert.equal 110, sprite.image('100x300').positionY
      assert.isUndefined sprite.image('350x151')
