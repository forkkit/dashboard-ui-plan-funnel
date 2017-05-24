base = require 'jade/base'
# screens
CreateAccount = require 'screens/create-account'
Home          = require 'screens/home'
PickPlan      = require 'screens/pick-plan'
Pay           = require 'screens/pay'

module.exports = class ScreenMachine

  constructor: (@config) ->
    @build(@config.$holder)

  showHome     : ()=> @changeScreen 'home'
  showPickPlan : ()=> @changeScreen 'pick-plan'
  showPay      : ()=> @changeScreen 'pay'

  refreshPage  : ()-> window.location.reload false

  submitPaymentAndPlan : () ->


  changeScreen : (screen) ->
    if @currentScreen?
      @currentScreen.hide()

    switch screen
      when 'create-account'
        if !@createAccount? then @createAccount = new CreateAccount @$el, @config.createAccount, @showHome
        @currentScreen = @createAccount

      when 'home'
        if !@home? then @home = new Home @$el, @config, @showPickPlan
        @currentScreen = @home

      when 'pick-plan'
        if !@pickPlan? then @pickPlan = new PickPlan @$el, @config, @refreshPage, @showPay
        @currentScreen = @pickPlan

      when 'pay'
        if !@pay? then @pay = new Pay @$el, @config.paymentConfig
        @currentScreen = @pay

    @currentScreen.show()

  build : ($parent) ->
    @$el = $ base( {} )
    $parent.append @$el
