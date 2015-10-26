define [
  "jquery"
  "backbone"
  "cs!views/GaugeView"
  "cs!views/ChartView"
  "tpl!templates/AppScaffolding.tpl"
], ($, Backbone, GaugeView, ChartView, scaffolding) -> Backbone.View.extend
  el: '#main'

  initialize: ->
    do @render


  render: ->
    @$el.html scaffolding()
    
    @chart = new ChartView
      model: @model
      el: @$('#archive')
    
    @gauge = new GaugeView
      model: @model
      el: @$('#current')
