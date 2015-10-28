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
    
    @gauge = new GaugeView
      model: @model
      el: @$('#current')
    
    @rainfall = new ChartView
      model: @model.rainfallData
      el: @$('#rainfall')
      title: "Rainfall in last 24 hours (mm/hour)"
      img: 'rain'
    
    @moisture = new ChartView
      model: @model.moistureData
      el: @$('#moisture')
      title: "Soil moisture  in last 24 hours (mean %/hour)"
      img: 'moisture'
    
    @sheep = new ChartView
      model: @model.sheepData
      el: @$('#sheep')
      title: "Sheep in high risk areas during last 24 hours (min/hour)"
      img: 'sheep'
