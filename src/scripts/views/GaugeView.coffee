define [
  "jquery"
  "backbone"
  "tpl!templates/GaugeScaffolding.tpl"
  "gauge"
], ($, Backbone, scaffolding, Gauge) -> Backbone.View.extend

  events:
    'click': 'updatePollutionRisk'

  initialize: ->
    do @render
    @listenTo @model, 'change:pollutionRisk', @render

  render: -> 
    @$el.html scaffolding
      risk: @riskInfo()
    do @addGauge

  addGauge: ->
    @gauge = new Gauge @$('#gauge')[0], {'arcColor': 'green'}
    @gauge.render([0, 0.2, 0.4, 0.6, 0.8, 1.0], 0.6, 0.8)
    @gauge.renderValue(@model.get 'pollutionRisk')

  riskInfo: ->
    if @model.get('pollutionRisk') > 0.8
      'text': 'HIGH'
      'class': 'alert-danger'
    else if @model.get('pollutionRisk') > 0.6
      'text': 'MEDIUM'
      'class': 'alert-warning'
    else if @model.get('pollutionRisk') <= 0.6
      'text': 'LOW'
      'class': 'alert-info'

  updatePollutionRisk: ->
    @model.set 'pollutionRisk', 0.82
