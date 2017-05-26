Screen = require 'screens/screen'
pickPlan = require 'jade/pick-plan'

module.exports = class PickPlan extends Screen

  constructor: (@$el, @config, @refreshPage, @gotoHome, @gotoAddPayment) ->
    @build @config
    @plans =
      individual : {name:"Individual", cost:10}
      team       : {name:"Team", cost:20}

  build : (@config) ->
    @$node = $ pickPlan( @config )
    if @config.isTeam
      $('.col.individual', @$node).addClass 'hidden'
    @$el.append @$node
    castShadows @$node
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

    $(".back-btn", @$node).on 'click', @gotoHome

    # Column Clicking
    $col = $('.col', @$node)
    $col.on 'click', (e)=>
      @selectedPlan = e.currentTarget.dataset.id
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


  getSelectedPlan : () -> @plans[@selectedPlan]

  createTeam : (cb) ->
    teamName = $("#team-name", @$node).val()
    @config.createTeam teamName, (data)=>
      if data.error?
        return
      cb(data)
