Screen = require 'screens/screen'
module.exports = class Form extends Screen

  constructor: () ->
    @$errors = $ "#errors", @$node

  showErrors : (errors) ->
    @$errors.removeClass 'hidden'
    $(".error", @$errors).html errors

  clearErrors : () ->
    @$errors.addClass 'hidden'
