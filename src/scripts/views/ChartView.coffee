define [
  "jquery"
  "backbone"
  "tpl!templates/ChartScaffolding.tpl"
  "chartjs"
], ($, Backbone, scaffolding, Chart) -> Backbone.View.extend

  initialize: (options) ->
    @options = options
    do @render
    do @chart

  render: -> 
    @$el.html scaffolding @options

  chart: ->
    Chart.defaults.global.responsive = false
    ctx = @$('#archive-chart')[0].getContext("2d")

    data = 
      labels: @labels()
      datasets: [
        label: "Pollution runoff risk",
        fillColor: "rgba(151,187,205,0.5)",
        strokeColor: "rgba(151,187,205,0.8)",
        highlightFill: "rgba(151,187,205,0.75)",
        highlightStroke: "rgba(151,187,205,1)",
        barDatasetSpacing: 1;
        data: @data()
      ]

    new Chart(ctx).Bar(data, {"barValueSpacing": 1})

  labels: ->
    _.chain @model
      .sortBy (val) ->
        val.time
      .pluck 'time'
      .map (val) ->
        val.substring(11,13)
      .value()

  data: ->
    _.chain @model
      .sortBy (val) ->
        val.time
      .pluck 'value'
      .value()

