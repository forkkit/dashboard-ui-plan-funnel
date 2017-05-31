createAccount = require 'jade/create-account'
Form = require 'screens/form'

module.exports = class CreateAccount extends Form

  constructor: (@$el, @config, @submitSuccessCb, @switchToSignin) ->
    @build()
    super()

  build : () ->
    @$node = $ createAccount( {} )
    @$el.append @$node
    lexify @$node
    @$createBtn = $("#create-account", @$node)
    $("#switch", @$node).on 'click', @switchToSignin
    $("form", @$node).on 'submit', (e)=> e.preventDefault(); @submitForm()
    @$createBtn.on 'click', ()=> @submitForm()

  submitForm : () =>
    @$createBtn.addClass 'ing'
    # If a robot filled out a hidden field, kill submission
    return if $("#hal-prevention", @$node).val().length > 0
    data =

      username    : $("#username", @$node).val()
      email       : $("#email", @$node).val()
      password    : $("#password", @$node).val()
      meta        :
        role            : $("#role", @$node).val()
        eula_accepted   : if $("#eula").is(':checked') then "1" else "0"

    # @setNames data
    @config.createAccount data, (result)=>
      @$createBtn.removeClass 'ing'
      @clearErrors()
      if result.error?
        @showErrors result.error
      else
        if @config.doRedirect
          window.location = result.redirect
        else
          @submitSuccessCb()

  # Find the first name
  setNames : (data) ->
    name = $("#name", @$node).val()
    names = name.split(' ')
    data.name      = name
    data.firstName = names[0]
