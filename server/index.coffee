path    = require "path"

express = require "express"

q       = require "q"


exports.app    = app    = express()
exports.server = server = require("http").createServer app
exports.io     = io     = require("socket.io").listen server, log: false


exports.cacheTime = cacheTime = 86400000

staticDir = (p) ->
  express.static path.join(__dirname, p),
    maxAge: cacheTime
    redirect: false


app.configure "development", ->
  app.use require("connect-livereload")()
  app.use express.errorHandler()
  app.use express.logger "dev"

  app.use                staticDir "../.tmp"
  app.use "/components", staticDir "../components"
  app.use                staticDir "../client"


app.configure ->
  app.use staticDir "../public"

  app.use app.router

  app.use express.urlencoded()
  app.use express.methodOverride()
  app.use express.json()


# Start server
ready = q.defer()

port = process.env.PORT or 8000
server.listen port, ->
  console.log "Listening on port %d in %s mode", port, app.get("env")
  ready.resolve "resolving!"

exports.ready = ready.promise

exports.indexRoute = (req, res) ->
  console.log "index route!"
  res.sendfile path.resolve "#{__dirname}/../public/index.html"

