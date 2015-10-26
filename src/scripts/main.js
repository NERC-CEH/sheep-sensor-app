require.config({
  stubModules: ['tpl', 'json', 'cs'],
  shim: {
    'bootstrap': { deps: ['jquery']},
    'gauge': { exports: 'Gauge'}
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
    'c3': '../vendor/c3/c3',
    'cs': '../vendor/require-cs/cs',
    'coffee-script': '../vendor/coffee-script/extras/coffee-script',
    'gauge': '../vendor/gauge/src/gauge',
    'chartjs': '../vendor/chartjs/Chart'
  },
  waitSeconds:1000
}); 

require(['cs!Main'], function(){});
