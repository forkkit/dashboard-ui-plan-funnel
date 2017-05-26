Screen = require 'screens/screen'
pay = require 'jade/pay'

module.exports = class Pay extends Screen

  constructor: (@$el, @config, @gotoPickPlan, @getSelectedPlan) ->
    @build()

  build : () ->
    console.log {plan:@getSelectedPlan()}
    @$node = $ pay( {plan:@getSelectedPlan()} )
    @$el.append @$node
    castShadows @$node

    $(".back-btn", @$node).on 'click', @gotoPickPlan

    @config.getPaymentConfig (paymentConfig)=>
      if paymentConfig.error
        console.log "Errors getting payment config:"
        console.log paymentConfig.error
        return

      @payMethods = new nanobox.PaymentMethods $(".payment-wrapper", @$node), paymentConfig, false
      @payMethods.createPayMethod {}, $(".payment-wrapper", @$node), true
