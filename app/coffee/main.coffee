CreateAccount = require 'screens/create-account'
ScreenMachine = require 'screen-machine'
PromoCode     = require 'promo-code'
class PlanFunnel

  constructor: (@config) ->
    @inspectData()
    @screenMachine = new ScreenMachine @config, @addPromoCode

    if @config.buyNow
      $(".plan-funnel", @config.$holder).addClass 'buy-now'

    # They have an account, show their home!
    if @config.hasAccount
      @screenMachine.changeScreen 'home'
    # No account, let's create one or login:
    else
      if @config.showSignin
        @screenMachine.changeScreen 'sign-in'
      else
        @screenMachine.changeScreen 'create-account'

  # Draw any assumptions about the data we need
  inspectData : () ->
    # @config.hasPaymentMethod = @config.paymentConfig.paymentMethod.length >= 1

  addPromoCode : (context) =>
    if @promo? then @promo.destroy()
    if  @config.promoCode?
      @promo = new PromoCode(@screenMachine.$el, context)

window.nanobox ||= {}
nanobox.PlanFunnel = PlanFunnel
