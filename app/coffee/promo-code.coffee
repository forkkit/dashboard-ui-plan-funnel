promo = require 'jade/promo'

module.exports = class PromoCode

  constructor: (@$el, context) ->
    preText = if context == "create-account" then "Creating an account" else "Logging in"
    @$promo = $ promo( {preText:preText} )
    @$el.prepend @$promo
    $("#sessions").addClass 'promo-active'
    castShadows @$promo

  destroy : ()->
    @$promo.remove()
    @$promo = null
