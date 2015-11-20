define [
  "jquery"
  "backbone"
  "cs!views/ChartView"
  "cs!views/GaugeView"
  "tpl!templates/AppScaffolding.tpl"
], ($, Backbone, ChartView, GaugeView, scaffolding) -> Backbone.View.extend
  el: '#main'

  initialize: ->
    do @render

  render: ->
    @$el.html scaffolding()
    
    @currentGauge = new GaugeView
      model: @model.currentPollutionRisk
      el: @$('#currentGauge')
      title: 'Current pollution event risk: '
    
    @currentChart = new ChartView
      model: @model.pollutionRiskData
      el: @$('#currentChart')
      title: 'Predicted probablity of pollution events in the last 24 hours'
      img: 'sheep'

    @forecastGauge = new GaugeView
      model: @model.forecastPollutionRisk
      el: @$('#forecastGauge')
      title: 'Risk of a pollution event in next 24 hours: '
    
    @forecastChart = new ChartView
      model: @model.pollutionRiskForecastData
      el: @$('#forecastChart')
      title: 'Pollution event risks during next 24 hours'
      img: 'sheep'
    
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

    @forecasts = new ChartView
      model: @model.forecastData
      el: @$('#forecasts')
      title: "Live met office rainfall forecast for next 24 hours (probability per 3 hours)"
      img: 'rain'
