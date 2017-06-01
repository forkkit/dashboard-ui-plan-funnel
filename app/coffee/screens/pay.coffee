Screen = require 'screens/screen'
pay = require 'jade/pay'

module.exports = class Pay extends Screen

  constructor: (@$el, @config, @gotoPickPlan, @getSelectedPlan) ->
    @build()

  build : () ->
    @$node = $ pay( {plan:@getSelectedPlan()} )
    @$el.append @$node
    castShadows @$node

    $(".back-btn", @$node).on 'click', @gotoPickPlan

    @config.getPaymentConfig (paymentConfig)=>
      if paymentConfig.error
        console.log "Errors getting payment config:"
        console.log paymentConfig.error
        return

      @realPaymentCreateCb = paymentConfig.createPaymentMethod
      paymentConfig.createPaymentMethod = @onPaymentReady
      @payMethods = new nanobox.PaymentMethods $(".payment-wrapper", @$node), paymentConfig, false
      @payMethods.createPayMethod {}, $(".payment-wrapper", @$node), true

  onPaymentReady : (data, nonce, cb) =>
    @realPaymentCreateCb data, nonce, ()=>
      if data.error?
        cb(data)
      else
        if @config.buyNow
          parent.postMessage {message:'redirect', newUrl:@config.dashboardUrl}, '*'
        else
          window.location = @config.launchAppPath



  # W3 always want to build this one fresh, so on hide, we'll also destroy! X-]
  hide : () ->
    super()
    $(".back-btn", @$node).off()
    @$node.remove()
    @payMethods = null
    @$el        = null
    @$node      = null
