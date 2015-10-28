define [
  'underscore'
  'backbone'
  'json!data/rainfall.json'
  'json!data/moisture.json'
  'json!data/sheep.json'
], (_, Backbone, rainfall, moisture, sheep) -> Backbone.Model.extend
  
  initialize: ->
    @rainfallData = rainfall
    @moistureData = moisture
    @sheepData = sheep
    do @updatePollutionRisk

  updatePollutionRisk: -> @set
    pollutionRisk: @soilSaturation()

  soilSaturation: ->
    #Get the latest % moisture value and scale to 1
    return _.chain @moistureData
      .sortBy 'time'
      .map (measurement) -> 
        measurement.value / 100
      .last()
      .value()
