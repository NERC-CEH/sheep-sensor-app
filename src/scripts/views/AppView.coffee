define [
  "jquery"
  "backbone"
  "cs!views/GaugeView"
  "tpl!templates/AppScaffolding.tpl"
], ($, Backbone, GaugeView, scaffolding) -> Backbone.View.extend
  el: '#main'

  initialize: ->
    do @render


  render: ->
    @$el.html scaffolding()
    
    @gauge = new GaugeView
      model: @model
      el: @$('#sheep-pollutant')
