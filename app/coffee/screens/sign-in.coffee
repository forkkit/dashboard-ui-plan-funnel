Form = require 'screens/form'
signIn = require 'jade/sign-in'

module.exports = class Signin extends Form

  constructor: ($el, @config, @submitSuccessCb, @createAccountCb) ->
    @build $el
    super()

  build : ($el) ->
    @$node = $ signIn( {} )
    $el.append @$node
    lexify @$node

    @$login = $("#login", @$node)
    $("#switch", @$node).on 'click', @createAccountCb
    $("form", @$node).on 'submit', (e)=>e.preventDefault(); @submitForm()
    @$login.on 'click',            ()=> @submitForm()

  submitForm : () =>
    @$login.addClass 'ing'
    # If a robot filled out a hidden field, kill submission
    return if $("#hal-prevention", @$node).val().length > 0
    data =
      username    : $("#username", @$node).val()
      password    : $("#password", @$node).val()

    # @setNames data
    @config.signIn data, (result)=>
      @$login.removeClass 'ing'
      @clearErrors()
      if result.error?
        @showErrors result.error
      else
        window.location = result.redirect
        @submitSuccessCb()
