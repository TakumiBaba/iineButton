#!/usr/bin/env coffee

require 'coffee-script'
global._ = require 'underscore'

http     = require 'http'
routes   = require './routes'
express  = require 'express'
net      = require 'net'
app      = express()
birthday = 1218
io       = require("socket.io").listen app


app.configure ->
  app.set 'port', process.env.PORT || birthday
  app.set 'port', birthday
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
app.post "/upload", routes.upload
app.get "/images/num/:num", routes.latestImages
app.get "/images/start/:start/num/:num", routes.images
app.get "/images/all", routes.allImages
app.get "/count_up", routes.countUp
app.get "/count_set/:count", routes.countSet
app.get "/initialize/count", routes.initializeCount
app.get "/initialize/image", routes.initializeImage

io.sockets.on "connection", (socket)->



http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get 'port'}"
