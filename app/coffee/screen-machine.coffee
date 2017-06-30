base = require 'jade/base'
# screens
CreateAccount = require 'screens/create-account'
SignIn        = require 'screens/sign-in'
Home          = require 'screens/home'
Legacy        = require 'screens/legacy'
PickPlan      = require 'screens/pick-plan'
Pay           = require 'screens/pay'

module.exports = class ScreenMachine

  constructor: (@config, @addPromoCodeCb) ->
    @build(@config.$holder)

  showCreateAccount : ()=> @changeScreen 'create-account'
  showSignin        : ()=> @changeScreen 'sign-in'
  showHome          : ()=> @changeScreen 'home'
  showPickPlan      : ()=> @changeScreen 'pick-plan'
  showPay           : ()=> @changeScreen 'pay'
  showLegacy        : ()=> @changeScreen 'legacy'

  refreshPage  : ()-> window.location.reload false

  submitPaymentAndPlan : () ->


  changeScreen : (screen) ->
    if @currentScreen?
      @currentScreen.hide()

    switch screen
      when 'sign-in'
        if !@signIn? then @signIn = new SignIn @$el, @config, @showHome, @showCreateAccount
        @addPromoCodeCb(screen)
        @currentScreen = @signIn

      when 'create-account'
        if !@createAccount? then @createAccount = new CreateAccount @$el, @config, @showHome, @showSignin
        @addPromoCodeCb(screen)
        @currentScreen = @createAccount

      when 'home'
        if @config.buyNow
          @gotToCorrectBuyNowPage()
          return
        else if @config.showLegacy
          @showLegacy()
          return

        if !@home? then @home = new Home @$el, @config, @showPickPlan
        @currentScreen = @home

      when 'pick-plan'
        if !@pickPlan? then @pickPlan = new PickPlan @$el, @config, @refreshPage, @showHome, @showPay
        @currentScreen = @pickPlan

      when 'pay'
        @pay = new Pay @$el, @config, @showPickPlan, @getSelectedPlan
        @currentScreen = @pay

      when 'legacy'
        @legacy = new Legacy @$el, @showPickPlan
        @currentScreen = @legacy

    @currentScreen.show()

  getSelectedPlan : () =>
    if @pickPlan?
      @pickPlan.getSelectedPlan()
    else
      PickPlan.getPlan @config.buyNowPlan

  gotToCorrectBuyNowPage : () ->
    if @config.buyNowPlan == 'individual'
      @showPay()
    else if @config.buyNowPlan == 'team'
      @showPickPlan()
    else if @config.buyNowPlan == 'local'
      window.location = @config.dashboardUrl
    else
      @showPickPlan()

  build : ($parent) ->
    @$el = $ base( {} )
    $parent.append @$el
