define [
  'cs!models/App'
  'cs!views/AppView'
], (App, AppView) ->
  window.app = new App()
  window.view = new AppView model: app
