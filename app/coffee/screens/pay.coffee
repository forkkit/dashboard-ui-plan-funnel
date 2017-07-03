Form = require 'screens/form'
pay = require 'jade/pay'

module.exports = class Pay extends Form

  constructor: (@$el, @config, @gotoPickPlan, @getSelectedPlan) ->
    @build()
    super()

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
    @clearErrors()
    if data.error?
      @showErrors result.error
    else
      @realPaymentCreateCb data, nonce, ()=>
        if @config.buyNow
          parent.postMessage {message:'redirect', newUrl:@config.dashboardUrl}, '*'
        else if @config.showLegacy
          window.location = @config.dashboardUrl
        else
          window.location = @config.launchAppPath

  # We always want to build this one fresh, so on hide, we'll also destroy! X-]
  hide : () ->
    super()
    $(".back-btn", @$node).off()
    @$node.remove()
    @payMethods = null
    @$el        = null
    @$node      = null
