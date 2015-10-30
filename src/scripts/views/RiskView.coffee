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
    @$el.html scaffolding
      risk: @riskInfo()
    do @addGauge
    do @addChart

  addGauge: ->
    @gauge = new Gauge @$('#gauge')[0], {'arcColor': 'green'}
    @gauge.render([0, 0.2, 0.4, 0.6, 0.8, 1.0], 0.6, 0.8)
    @gauge.renderValue(@model.get 'pollutionRisk')

  addChart: ->
    riskInfo = @riskInfo()
    @chart = new ChartView
      model: @model.pollutionRiskData
      el: @$('#risk-chart')
      title: "Pollution risk in last 24 hours (mm/hour)"
      img: 'sheep'
      panelType: riskInfo.panelType

  riskInfo: ->
    if @model.get('pollutionRisk') > 0.8
      'text': 'HIGH'
      'panelType': 'danger'
    else if @model.get('pollutionRisk') > 0.6
      'text': 'MEDIUM'
      'panelType': 'warning'
    else if @model.get('pollutionRisk') <= 0.6
      'text': 'LOW'
      'panelType': 'info'

  updatePollutionRisk: ->
    @model.set 'pollutionRisk', Math.random()
