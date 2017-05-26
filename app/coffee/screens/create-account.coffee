createAccount = require 'jade/create-account'
Screen = require 'screens/screen'

module.exports = class CreateAccount extends Screen

  constructor: (@$el, @submit, @submitSuccessCb, @switchToSignin) ->
    @build()

  build : () ->
    @$node = $ createAccount( {} )
    @$el.append @$node
    lexify @$node
    $("#create-account").on 'click', @submitForm
    $("#switch", @$node).on 'click', @switchToSignin

  submitForm : () =>
    # If a robot filled out a hidden field, kill submission
    return if $("#hal-prevention", @$node).val().length > 0
    data =

      username    : $("#username", @$node).val()
      email       : $("#email", @$node).val()
      password    : $("#password", @$node).val()
      meta        :
        role            : $("#role", @$node).val()
        eula_accepted   : "1"

    # @setNames data
    @submit data, (data)=>
      if data.error?
        # TODO: Handler errors
        console.log data.error
      else
        @submitSuccessCb()

  # Find the first name
  setNames : (data) ->
    name = $("#name", @$node).val()
    names = name.split(' ')
    data.name      = name
    data.firstName = names[0]
