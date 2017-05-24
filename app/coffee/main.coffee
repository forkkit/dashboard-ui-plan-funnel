CreateAccount = require 'screens/create-account'
ScreenMachine = require 'screen-machine'
class PlanFunnel

  constructor: (@config) ->
    @inspectData()
    @screenMachine = new ScreenMachine @config

    # They have an account, show their home!
    if @config.hasAccount
      @screenMachine.changeScreen 'home'
    # No account, let's create one:
    else
      @screenMachine.changeScreen 'create-account'

  # Draw any assumptions about the data we need
  inspectData : () ->
    @config.hasPaymentMethod = @config.paymentConfig.paymentMethod.length >= 1
    console.log @config

window.nanobox ||= {}
nanobox.PlanFunnel = PlanFunnel
