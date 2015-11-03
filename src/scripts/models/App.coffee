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
    @forecasts = new Forecasts
    @rainfallData = new Forecasts rainfall
    @moistureData = new Forecasts moisture
    @sheepData = new Forecasts sheep
    @pollutionRiskData = new Forecasts rainfall
    @listenTo @forecasts, 'sync', @updateForecastRisk
    do @setForecasts
    @set 'pollutionRiskForecast', Math.random()
    do @updateCurrentRisk

  setForecasts: ->
    @forecasts.fetch
      "error": (e) ->
        console.log 'error fetching forecasts'
        console.log e
      "data":
        "key": "d90d73a0-f703-421e-b638-e9f39d42a178"
        "res": "3hourly"

  updateCurrentRisk: -> @set
    pollutionRisk: @soilSaturation() * @runoffRisk()

  updateForecastRisk: -> @set
    pollutionRiskForecast: @soilSaturation() * @runoffRiskForecast()

  highRiskLocation: ->
    #If sheep have been in high risk area 

  soilSaturation: ->
    #Get the latest % moisture value and scale to 1, with a min value of 0.1
    return @moistureData
      .chain()
      .sortBy 'time'
      .map (measurement) -> 
        (measurement.get('value') + 10) / 110
      .last()
      .value()

  runoffRisk: ->
    #Sum up the last 3 hours of rainfall and map to the following values to give a risk of runoff
    threeHourTotal = @rainfallData
      .chain()
      .sortBy 'time'
      .reverse()
      .reduce (memo, data, index) ->
        memo += data.get('value') if index < 3
        return memo
      , 0
      .value()
    return @rainfall2RunoffRisk(threeHourTotal)

  runoffRiskForecast: ->
    #Take the maximum risk value for the next 24 hours of forecasts
    #note: each rainfall forecast value is total mm rainfall in a 3 hour period
    return @forecasts.max (forecast) ->
      console.log forecast.get 'value'
      forecast.get 'value'

  rainfall2RunoffRisk: (threeHourTotal) ->
    #Given an input of total rainfall in mm in a 3 hour period, calculate the risk of runoff as follows:
    if threeHourTotal > 8
      return 1
    else if threeHourTotal > 3.9
      return (threeHourTotal - 3.9) / 6
    else
      return 0.1
