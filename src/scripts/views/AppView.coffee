define [
  "jquery"
  "backbone"
  "cs!views/RiskView"
  "cs!views/ChartView"
  "tpl!templates/AppScaffolding.tpl"
], ($, Backbone, RiskView, ChartView, scaffolding) -> Backbone.View.extend
  el: '#main'

  initialize: ->
    do @render

  render: ->
    @$el.html scaffolding()
    
    @risk = new RiskView
      model: @model
      el: @$('#risk')
    
    @rainfall = new ChartView
      model: @model.rainfallData
      el: @$('#rainfall')
      title: "Rainfall in last 24 hours (mm/hour)"
      img: 'rain'
      panelType: 'success'

    @moisture = new ChartView
      model: @model.moistureData
      el: @$('#moisture')
      title: "Soil moisture  in last 24 hours (mean %/hour)"
      img: 'moisture'
      panelType: 'success'
    
    @sheep = new ChartView
      model: @model.sheepData
      el: @$('#sheep')
      title: "Sheep in high risk areas during last 24 hours (min/hour)"
      img: 'sheep'
      panelType: 'success'

    @forecasts = new ChartView
      model: @model.forecasts
      el: @$('#forecasts')
      title: "Rainfall forecast for next 24 hours (mm/3 hours)"
      img: 'rain'
      panelType: 'success'
