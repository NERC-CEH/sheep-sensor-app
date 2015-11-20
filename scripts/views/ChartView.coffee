define [
  "jquery"
  "backbone"
  "tpl!templates/ChartScaffolding.tpl"
  "chartjs"
], ($, Backbone, scaffolding, Chart) -> Backbone.View.extend

  initialize: (options) ->
    @options = options

    @listenTo @model, 'sync', @refresh
    @listenTo @model, 'add', @refresh
    do @render
    do @chart

  render: -> 
    @$el.html scaffolding @options

  chart: ->
    Chart.defaults.global.responsive = false
    ctx = @$('.chart canvas')[0].getContext("2d")
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

    @barchart = new Chart(ctx).Bar(data, {"barValueSpacing": 0})

  refresh: ->
    #Destroy the bar chart and redraw
    do @barchart.destroy
    do @chart


  labels: ->
    @model
      .chain()
      .sortBy (val) -> val.get('time')
      .map (val) -> val.get('time').substring(11,13)
      .value()

  data: ->
    @model
      .chain()
      .sortBy (val) -> val.get 'time'
      .map (val) -> val.get 'value'
      .value()

