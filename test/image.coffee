Image = require '../lib/image'

path = './test/images/global'

module.exports =
  testImageDimensions: (beforeExit, assert) ->
    image = new Image '100x300.png', path
    image.readDimensions ->
      assert.equal 100, image.width
      assert.equal 300, image.height