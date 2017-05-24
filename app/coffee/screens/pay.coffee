Screen = require 'screens/screen'
pay = require 'jade/pay'

module.exports = class Pay extends Screen

  constructor: (@$el, paymentConfig) ->
    @build paymentConfig


  build : (paymentConfig) ->
    @$node = $ pay( {} )
    @$el.append @$node
    castShadows @$node
    @payMethods = new nanobox.PaymentMethods $(".payment-wrapper", @$node), paymentConfig, false
    @payMethods.createPayMethod {}, $(".payment-wrapper", @$node), true
