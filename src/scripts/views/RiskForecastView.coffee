define [
  "jquery"
  "backbone"
  "tpl!templates/RiskForecastScaffolding.tpl"
  "views/ChartView"
  "gauge"
], ($, Backbone, scaffolding, ChartView, Gauge) -> Backbone.View.extend

  initialize: ->
    @listenTo @model, 'change:pollutionRiskForecast', @render
    @listenTo @model, 'change:pollutionRiskForecastData', @render

  render: -> 
    @riskText = 
      risk: @riskInfo(@model.get('pollutionRiskForecast'))

    @$el.html scaffolding @riskText
    do @addGauge
    do @addChart

  addGauge: ->
    @gauge = new Gauge @$('.gauge')[0], {'arcColor': 'green'}
    @gauge.render([0, 0.2, 0.4, 0.6, 0.8, 1.0], 0.6, 0.8)
    @gauge.renderValue(@model.get 'pollutionRiskForecast')

  addChart: ->
    @chartForecast = new ChartView
      model: @model.pollutionRiskForecastData
      el: @$('#risk-chart')
      title: "Predicted pollution risk for next 24 hours"
      img: 'sheep'
      panelType: @riskText.risk.panelType

  riskInfo: (val) ->
    if val > 0.8
      'text': 'HIGH'
      'panelType': 'danger'
    else if val > 0.6
      'text': 'MEDIUM'
      'panelType': 'warning'
    else if val <= 0.6
      'text': 'LOW'
      'panelType': 'info'
