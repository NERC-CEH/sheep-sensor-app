define [
  'underscore'
  'backbone'
  'json!data/rainfall.json'
  'json!data/moisture.json'
  'json!data/sheep.json'
  'cs!models/Risk'
  'cs!models/EnvironmentalMeasurement'
  'cs!collections/EnvironmentalMeasurements'
], (_, Backbone, rainfall, moisture, sheep, Risk, EnvironmentalMeasurement, EnvironmentalMeasurements) -> Backbone.Model.extend
  
  initialize: ->
    @latestData = '2015-10-28T11:00:00.000Z'
    @rainfallData = new EnvironmentalMeasurements rainfall
    @moistureData = new EnvironmentalMeasurements moisture
    @sheepData = new EnvironmentalMeasurements sheep
    @forecastData = new EnvironmentalMeasurements
    @pollutionRiskData = new EnvironmentalMeasurements
    @pollutionRiskForecastData = new EnvironmentalMeasurements
    @currentPollutionRisk = new Risk
    @forecastPollutionRisk = new Risk
    @listenTo @forecastData, 'sync', @updateForecastDependencies
    do @updateCurrentRisk
    do @setForecasts

  updateForecastDependencies: ->
    do @updatePollutionRiskForecastData
    @forecastPollutionRisk.set 'risk', (@pollutionRiskForecastData.max (forecast) -> forecast.get 'value').get('value')

  updatePollutionRiskForecastData: ->
    @pollutionRiskForecastData.reset()
    @forecastData.each (measurement) =>
      @pollutionRiskForecastData.add
        'time': measurement.get 'time'
        'value': @soilSaturation(@latestData) * @rainfall2RunoffRisk(measurement.get('value'))

  setForecasts: ->
    @forecastData.fetch
      "error": (e) ->
        console.log 'Error fetching forecasts'
        console.log e
      "data":
        "key": "d90d73a0-f703-421e-b638-e9f39d42a178"
        "res": "3hourly"

  updateCurrentRisk: -> 
    @currentPollutionRisk.set 'risk', @pollutionRiskValue(@latestData)
    @rainfallData.each (measurement) =>
      @pollutionRiskData.add
        'time': measurement.get 'time'
        'value': @pollutionRiskValue(measurement.get('time'))

  pollutionRiskValue: (time) ->
    return (@soilSaturation(time) * @runoffRisk(time))

  #Risk value based on time spent by sheep in high risk locations
  highRiskLocation: ->

  #Get the % moisture value for the specified time and scale to 1, with a min value of 0.1
  soilSaturation: (time) ->
    value = @moistureData
      .chain()
      .find (measurement) ->
        return measurement.get('time') == time
      .value()
      .get 'value'
    return (value + 10) / 110

  #Runoff risk will be the sum of the last 3 hours of rainfall normalized to 1
  runoffRisk: (time) ->
    t = new Date(time)
    tMinus1 = new Date(time)
    tMinus2 = new Date(time)
    tMinus1.setHours(t.getHours() - 1)
    tMinus2.setHours(t.getHours() - 2)
    threeHourTotal = @rainfallData
      .chain()
      .filter (measurement) ->
        return (measurement.get('time') == t.toISOString() || measurement.get('time') == tMinus1.toISOString() || measurement.get('time') == tMinus2.toISOString())
      .reduce (memo, data, index) ->
        memo += data.get('value') if index < 3
        return memo
      , 0
      .value()
      return @rainfall2RunoffRisk threeHourTotal

  #Return the maximum pollution risk value for the next 24 hours of forecasts
  #note: each rainfall forecast value is total mm rainfall in a 3 hour period
  runoffRiskForecast: ->
    threeHourTotal =  @forecastData.max (forecast) ->
      forecast.get 'value'
    return @rainfall2RunoffRisk threeHourTotal.get('value')


  #Given an input of total rainfall in mm in a 3 hour period, calculate the risk of runoff
  rainfall2RunoffRisk: (threeHourTotal) ->
    if threeHourTotal > 30
      return 1
    else if threeHourTotal > 10
      return ((threeHourTotal - 9) / 21) * 0.9 #roughly 0.04 to 0.9
    else
      return 0.1
