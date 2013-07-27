require.config
  paths:
    jquery: '../bower_components/jquery/jquery'
    'jquery.transit': '../bower_components/jquery.transit/jquery.transit'
    bootstrap: 'vendor/bootstrap'
    handlebars: '../bower_components/handlebars/handlebars.runtime'

  shim:
    bootstrap:
      deps: ['jquery']
      exports: 'jquery'
    handlebars:
      exports: 'Handlebars'
      init: ->
        @Handlebars = Handlebars

require ["app", "jquery", "bootstrap"], (app, $) ->
  "use strict"
  
  # use app here
  console.log app
  console.log "Running jQuery %s", $().jquery

