define [
  'underscore'
  'backbone'
  'json!data/rainfall.json'
  'json!data/moisture.json'
  'json!data/sheep.json'
  'cs!models/Forecast'
  'cs!collections/Forecasts'
], (_, Backbone, rainfall, moisture, sheep, Forecast, Forecasts) -> Backbone.Model.extend
  
  initialize: ->
    @listenTo @, 'change:forecasts', @forecastsUpdated
    @set 'forecasts', new Forecasts
    @rainfallData = rainfall
    @moistureData = moisture
    @sheepData = sheep
    @pollutionRiskData = rainfall
    do @setForecasts
    do @updatePollutionRisk

  setForecasts: ->
    @get('forecasts').fetch
      "data":
        "key": "d90d73a0-f703-421e-b638-e9f39d42a178"
        "res": "3hourly"

  updatePollutionRisk: -> @set
    pollutionRisk: @soilSaturation() * @runoffRisk()

  soilSaturation: ->
    #Get the latest % moisture value and scale to 1
    return _.chain @moistureData
      .sortBy 'time'
      .map (measurement) -> 
        measurement.value / 100
      .last()
      .value()

  runoffRisk: ->
    #Sum up the last 3 hours of rainfall and use these mappings to indicate risk of runoff
    # - 0 to < 4mm = 0.1
    # - 4mm to < 10mm = (amount - 3.9) / 6
    # - > 10mm = 1
    threeHourTotal = _.chain @rainfallData
      .sortBy 'time'
      .reverse()
      .reduce (memo, data, index) ->
        memo += data.value if index < 3
        return memo
      , 0
      .value()
    if threeHourTotal > 8
      return 1
    else if threeHourTotal > 3.9
      return (threeHourTotal - 3.9) / 6
    else
      return 0.1

  forecastsUpdated: (e) ->
    console.log e
    console.log 'forecast has been updated'
    console.log @.get('forecasts').toJSON()
