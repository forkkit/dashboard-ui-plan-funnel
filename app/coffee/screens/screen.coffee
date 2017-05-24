module.exports = class Screen

  constructor: () ->

  hide : () -> @$node.addClass 'hidden'
  show : () -> @$node.removeClass 'hidden'
