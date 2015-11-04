define [
  'underscore'
  'backbone'
  'cs!models/EnvironmentalMeasurement'
], (_, Backbone, EnvironmentalMeasurement) -> Backbone.Collection.extend

  #In this url 350502 is the key of a site (Bodant Gardens) in the Conway Catchment that the met office have forecast data for
  #Other sites are available: http://datapoint.metoffice.gov.uk/public/data/val/wxfcs/all/json/sitelist?res=daily&key=d90d73a0-f703-421e-b638-e9f39d42a178
  url: "http://datapoint.metoffice.gov.uk/public/data/val/wxfcs/all/json/350502"
  model: EnvironmentalMeasurement

  sync: (method, collection, options) ->
    _.extend
      "dataType": "jsonp"
    , options
    return Backbone.sync(method, collection, options)

  parse: (response) ->
    time = new Date(response.SiteRep.DV.dataDate)
    forecasts = []
    _.each response.SiteRep.DV.Location.Period, (day) ->
      _.each day.Rep, (forecast) ->
        forecasts.push
          "time": time.toISOString()
          "value": forecast.Pp
        time.setHours(time.getHours() + 3)
    return forecasts.slice 0, 8
