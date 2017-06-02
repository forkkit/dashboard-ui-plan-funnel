Screen = require 'screens/screen'
legacy = require 'jade/legacy'

module.exports = class Legacy extends Screen

  constructor : (@$el, @nextCb) ->
    @build()

  build : () ->
    @$node = $ legacy( {} )
    @$el.append @$node
    castShadows @$node
    $(".btn", @$node).on 'click', @nextCb
