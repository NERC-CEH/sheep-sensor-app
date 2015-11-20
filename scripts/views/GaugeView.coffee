define [
  "jquery"
  "backbone"
  "tpl!templates/GaugeScaffolding.tpl"
  "gauge"
], ($, Backbone, scaffolding, Gauge) -> Backbone.View.extend

  initialize: (options) ->
    @options = options
    do @render
    @listenTo @model, 'change', @render

  render: -> 
    @riskText = 
      risk: @riskInfo(@model.get 'risk')
    @$el.html scaffolding @riskText
    do @addGauge

  addGauge: ->
    @gauge = new Gauge @$('.gauge')[0], {'arcColor': 'green'}
    @gauge.render([0, 0.2, 0.4, 0.6, 0.8, 1.0], 0.6, 0.8)
    @gauge.renderValue(@model.get 'risk')

  riskInfo: (val) ->
    if val > 0.8
      'title': @options.title + ' HIGH'
      'panelType': 'danger'
    else if val > 0.6
      'title': @options.title + 'MEDIUM'
      'panelType': 'warning'
    else if val <= 0.6
      'title': @options.title + 'LOW'
      'panelType': 'success'
