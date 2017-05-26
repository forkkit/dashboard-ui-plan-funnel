Screen = require 'screens/screen'
signIn = require 'jade/sign-in'

module.exports = class Signin extends Screen

  constructor: ($el, @config, @submitSuccessCb, @createAccountCb) ->
    @build $el

  build : ($el) ->
    @$node = $ signIn( {} )
    $el.append @$node
    lexify @$node
    $("#switch", @$node).on 'click', @createAccountCb
    $("#login", @$node).on  'click', @submitForm

  submitForm : () =>
    # If a robot filled out a hidden field, kill submission
    return if $("#hal-prevention", @$node).val().length > 0
    data =
      username    : $("#username", @$node).val()
      password    : $("#password", @$node).val()

    # @setNames data
    @config.signIn data, (data)=>
      if data.error?
        # TODO: Handle errors
        console.log data.error
      else
        window.location = @config.dashboardPath
        @submitSuccessCb()
