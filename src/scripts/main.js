require.config({
  stubModules: ['tpl', 'json'],
  shim: {
    'leaflet': {exports: 'L'},
    'bootstrap': { deps: ['jquery']}
  },
  paths: {
    'bootstrap': '../vendor/bootstrap/dist/js/bootstrap.min',
    'tpl' : '../vendor/requirejs-tpl/tpl',
    'text' : '../vendor/requirejs-text/text',
    'json' : '../vendor/requirejs-json/json',
    'jquery' : '../vendor/jquery/dist/jquery',
    'underscore': '../vendor/underscore/underscore',
    'backbone': '../vendor/backbone/backbone',
    'd3': '../vendor/d3/d3',
    'c3': '../vendor/c3/c3'
  },
  waitSeconds:1000
}); 

require(['models/App', 'views/AppView'], function(App, AppView){ 
  app = new App();
  view = new AppView({model: app});
});
