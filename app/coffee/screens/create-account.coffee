createAccount = require 'jade/create-account'
Screen = require 'screens/screen'

module.exports = class CreateAccount extends Screen

  constructor: (@$el, @submit, @submitSuccessCb) ->
    @build()

  build : () ->
    @$node = $ createAccount( {} )
    @$el.append @$node
    lexify @$node
    $("#create-account").on 'click', @submitForm

  submitForm : () =>
    # If a robot filled out a hidden field, kill submission
    return if $("#hal-prevention").val().length > 0
    data =
     email    : $("#email").val()
     password : $("#password").val()
     company  : $("#company").val()
     role     : $("#role").val()

    @setNames data
    @submit data, (data)=>
      if data.error?
        # TODO: Handler errors
        console.log data.error
      else
        @submitSuccessCb()

  # Find the first name
  setNames : (data) ->
    name = $("#name").val()
    names = name.split(' ')
    data.name      = name
    data.firstName = names[0]
