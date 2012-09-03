#!/usr/bin/env coffee

require 'coffee-script'
global._ = require 'underscore'

http     = require 'http'
routes   = require './routes'
express  = require 'express'
app      = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.compress()
  app.use app.router
  app.use require('less-middleware') "#{__dirname}/public"
  app.use require('coffee-middleware') "#{__dirname}/public"
  app.use express.static "#{__dirname}/public"
  app.use routes.failed

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', routes.index

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get 'port'}"
