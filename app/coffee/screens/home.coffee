Screen = require 'screens/screen'
home = require 'jade/home'

module.exports = class Home extends Screen

  constructor: (@$el, @config, @gotoPickPlan) ->
    @build()

  build : () ->
    @$node = $ home( @config )
    @$el.append @$node
    castShadows @$node
    $("a#launch-an-app").on 'click', @gotoPickPlan
