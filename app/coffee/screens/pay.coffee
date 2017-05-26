Screen = require 'screens/screen'
pay = require 'jade/pay'

module.exports = class Pay extends Screen

  constructor: (@$el, @config) ->
    @build()

  build : () ->
    @$node = $ pay( {} )
    @$el.append @$node
    castShadows @$node
    @config.getPaymentConfig (paymentConfig)=>
      if paymentConfig.error
        console.log "Errors getting payment config:"
        console.log paymentConfig.error
        return

      @payMethods = new nanobox.PaymentMethods $(".payment-wrapper", @$node), paymentConfig, false
      @payMethods.createPayMethod {}, $(".payment-wrapper", @$node), true
