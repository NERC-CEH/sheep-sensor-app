define [
  "jquery"
  "backbone"
  "tpl!templates/RiskScaffolding.tpl"
  "views/ChartView"
  "gauge"
], ($, Backbone, scaffolding, ChartView, Gauge) -> Backbone.View.extend

  events:
    'click': 'updatePollutionRisk'

  initialize: ->
    do @render
    @listenTo @model, 'change:pollutionRisk', @render

  render: -> 
    @riskText = 
      riskCurrent: @riskInfo(@model.get('pollutionRisk'))
      riskForecast: @riskInfo(@model.get('pollutionRiskForecast'))

    @$el.html scaffolding @riskText
    do @addGauges
    do @addCharts

  addGauges: ->
    @gauge = new Gauge @$('#gauge-current')[0], {'arcColor': 'green'}
    @gauge.render([0, 0.2, 0.4, 0.6, 0.8, 1.0], 0.6, 0.8)
    @gauge.renderValue(@model.get 'pollutionRisk')

    randomPollutionRisk = Math.random()
    @gauge = new Gauge @$('#gauge-future')[0], {'arcColor': 'green'}
    @gauge.render([0, 0.2, 0.4, 0.6, 0.8, 1.0], 0.6, 0.8)
    @gauge.renderValue(@model.get 'pollutionRiskForecast')

  addCharts: ->
    @chartForecast = new ChartView
      model: @model.pollutionRiskData
      el: @$('#risk-chart')
      title: "Pollution risk in last 24 hours"
      img: 'sheep'
      panelType: @riskText.riskCurrent.panelType

    @chartPast = new ChartView
      model: @model.pollutionRiskData
      el: @$('#future-risk-chart')
      title: "Predicted pollution risk for next 24 hours"
      img: 'sheep'
      panelType: @riskText.riskForecast.panelType

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

  updatePollutionRisk: ->
    @model.set 'pollutionRisk', Math.random()
