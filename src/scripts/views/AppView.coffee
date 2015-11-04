define [
  "jquery"
  "backbone"
  "cs!views/RiskForecastView"
  "cs!views/ChartView"
  "cs!views/GaugeView"
  "tpl!templates/AppScaffolding.tpl"
], ($, Backbone, RiskForecastView, ChartView, GaugeView, scaffolding) -> Backbone.View.extend
  el: '#main'

  initialize: ->
    do @render

  render: ->
    @$el.html scaffolding()
    
    @currentGauge = new GaugeView
      model: @model.currentPollutionRisk
      el: @$('#currentGauge')
      title: 'Current risk of a pollution event: '
    
    @currentChart = new ChartView
      model: @model.pollutionRiskData
      el: @$('#currentChart')
      title: 'Pollution risk during the last 24 hours'
      img: 'sheep'

    @forecastGauge = new GaugeView
      model: @model.forecastPollutionRisk
      el: @$('#forecastGauge')
      title: 'Risk of a pollution event in next 24 hours: '
    
    @forecastChart = new ChartView
      model: @model.pollutionRiskForecastData
      el: @$('#forecastChart')
      title: 'Predicted pollution risk for next 24 hours'
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
      title: "Rainfall forecast for next 24 hours (mm/3 hours)"
      img: 'rain'
