Screen = require 'screens/screen'
pickPlan = require 'jade/pick-plan'

module.exports = class PickPlan extends Screen

  constructor: (@$el, @config, @refreshPage, @gotoAddPayment) ->
    @build @config

  build : (@config) ->
    @$node = $ pickPlan( @config )
    @$el.append @$node
    lexify @$node

    # Activate plan
    $("#activate-plan", @$node).on 'click', ()=>
      @setPlan (data)=>
        @config.hasPaymentMethod = true
        @refreshPage()

    # Next, add a payment method
    $("#next", @$node).on 'click', ()=>
      @setPlan (data)=>
        @gotoAddPayment()

    # Column Clicking
    $col = $('.col', @$node)
    $col.on 'click', (e)=>
      $col.removeClass 'active'
      $(e.currentTarget, @$node).addClass 'active'

    # Set Default:
    # TODO: We probably want to allow a to be passed in..
    $defualtColumn = $ ".col.default", @$node
    $defualtColumn.trigger 'click'
    $('label', $defualtColumn).trigger 'click'

  setPlan : (cb) ->
    plan = $("input:radio[name='plans']:checked").val()
    @config.setPlan plan, (data)=>
      if data.error?
        return
      cb(data)
