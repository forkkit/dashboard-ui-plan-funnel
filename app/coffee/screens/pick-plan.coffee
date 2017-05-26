Screen = require 'screens/screen'
pickPlan = require 'jade/pick-plan'

module.exports = class PickPlan extends Screen

  constructor: (@$el, @config, @refreshPage, @gotoAddPayment) ->
    @build @config

  build : (@config) ->
    @$node = $ pickPlan( @config )
    if @config.isTeam
      $('.col.individual', @$node).addClass 'hidden'
    @$el.append @$node
    lexify @$node

    # Activate plan
    $("#activate-plan", @$node).on 'click', ()=>
      @setPlan (data)=>
        @config.hasPaymentMethod = true
        @refreshPage()

    # Next, add a payment method
    $("#next", @$node).on 'click', ()=>
      @createTeam (data)=>
        @gotoAddPayment()

    # Column Clicking
    $col = $('.col', @$node)
    $col.on 'click', (e)=>
      $col.removeClass 'active'
      $(e.currentTarget, @$node).addClass 'active'
      if $(e.currentTarget).hasClass 'individual'
        @$node.removeClass 'name-team'
      else
        @$node.addClass 'name-team'

    # Set Default:
    # TODO: We probably want to allow the currently active plan to be passed in
    $defualtColumn = $ ".col.default", @$node
    $defualtColumn.trigger 'click'
    $('label', $defualtColumn).trigger 'click'


  createTeam : (cb) ->
    teamName = $("#team-name", @$node).val()
    @config.createTeam teamName, (data)=>
      if data.error?
        return
      cb(data)
