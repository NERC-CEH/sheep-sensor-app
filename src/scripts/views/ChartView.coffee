define [
  "jquery"
  "backbone"
  "tpl!templates/ChartScaffolding.tpl"
  "chartjs"
], ($, Backbone, scaffolding, Chart) -> Backbone.View.extend

  initialize: ->
    do @render
    do @chart

  render: -> 
    @$el.html scaffolding()

  chart: ->
    ctx = @$('#archive-chart')[0].getContext("2d")

    data = 
      labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
      datasets: [
        label: "My First dataset",
        fillColor: "rgba(151,187,205,0.5)",
        strokeColor: "rgba(151,187,205,0.8)",
        highlightFill: "rgba(151,187,205,0.75)",
        highlightStroke: "rgba(151,187,205,1)",
        data: [28, 48, 40, 19, 86, 27, 90]
      ]

    new Chart(ctx).Bar(data)
