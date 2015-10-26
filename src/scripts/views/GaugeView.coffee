define [
  "jquery"
  "backbone"
  "tpl!templates/GaugeScaffolding.tpl"
  "gauge"
], ($, Backbone, scaffolding, Gauge) -> Backbone.View.extend

  initialize: ->
    do @render
    do @gauge

  render: -> 
    @$el.html scaffolding()

  gauge: ->
    gauge = new Gauge @$('#gauge')[0], {'arcColor': 'green'}
    gauge.render([0, 20, 40, 60, 80, 100], 60, 80)
    gauge.renderValue(33)
