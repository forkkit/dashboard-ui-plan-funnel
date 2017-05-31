base = require 'jade/base'
# screens
CreateAccount = require 'screens/create-account'
SignIn        = require 'screens/sign-in'
Home          = require 'screens/home'
PickPlan      = require 'screens/pick-plan'
Pay           = require 'screens/pay'

module.exports = class ScreenMachine

  constructor: (@config) ->
    @build(@config.$holder)

  showCreateAccount : ()=> @changeScreen 'create-account'
  showSignin        : ()=> @changeScreen 'sign-in'
  showHome          : ()=> @changeScreen 'home'
  showPickPlan      : ()=> @changeScreen 'pick-plan'
  showPay           : ()=> @changeScreen 'pay'

  refreshPage  : ()-> window.location.reload false

  submitPaymentAndPlan : () ->


  changeScreen : (screen) ->
    if @currentScreen?
      @currentScreen.hide()

    switch screen
      when 'sign-in'
        if !@signIn? then @signIn = new SignIn @$el, @config, @showHome, @showCreateAccount
        @currentScreen = @signIn

      when 'create-account'
        if !@createAccount? then @createAccount = new CreateAccount @$el, @config, @showHome, @showSignin
        @currentScreen = @createAccount

      when 'home'
        if !@home? then @home = new Home @$el, @config, @showPickPlan
        @currentScreen = @home

      when 'pick-plan'
        if !@pickPlan? then @pickPlan = new PickPlan @$el, @config, @refreshPage, @showHome, @showPay
        @currentScreen = @pickPlan

      when 'pay'
        @pay = new Pay @$el, @config, @showPickPlan, @getSelectedPlan
        @currentScreen = @pay

    @currentScreen.show()

  getSelectedPlan : () => @pickPlan.getSelectedPlan()


  build : ($parent) ->
    @$el = $ base( {} )
    $parent.append @$el
