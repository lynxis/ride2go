socketIO = require 'socket.io'
express  = require 'express'
sys      = require 'util'

Ride = require './ride'
City = require('./place').City
RDS  = require './rds'
log  = require './logging'
mom  = require 'moment'

app = express()
app.set 'views', "view"
app.set 'view engine', 'jade'
app.locals.pretty = true
app.use express.bodyParser()
app.use express.static 'public'

server = app.listen 3000

io = socketIO.listen server
#io.set('log level', 1)

io.sockets.on 'connection', (socket) ->
  log.debug "socket connected"
  socket.on 'query', (query) ->
    log.info "query received -> #{JSON.stringify(query)}"
    unless query.origin
      query.origin = new City("DE:Berlin:Berlin") # geocoding serverbased
    City.find query.origin, (orig) ->
      log.info "found orig: #{orig.key} "
      City.find query.destination, (dest) ->
        log.info "found dest: #{dest.key}"
        RDS.match Ride.new(orig:orig,dest:dest), (matching_ride) ->
          log.debug "emitting ride to client: #{matching_ride}"
          socket.emit 'ride', matching_ride

app.get "/", (req,res) ->
  res.render 'index',  { layout: false, locals: {
      from: req.params.from ? "rungestrasse berlin" ,
      to: req.params.to ? "hauptstrasse 42 panketal"
  }}

app.get "/connectors/:name", (req, res) ->
  res.send RDS.get_connector(req.params.name)

app.get "/rides/:from/:to", (req, res) ->
  res.render 'index',  { layout: false, locals: {
      from: req.params.from , to: req.params.to }}

app.post "/rides", (req, res) ->
  browser.emit 'ride', {some: req.body.ride}
  res.send "foo"

app.get '/ridestream', (req, res) ->
  fromKey   = req.query.fromKey
  toKey     = req.query.toKey
  departure = req.query.departure
  if departure
    departure = parseInt departure
  else
    departure = mom().utc().unix()
  debugger;
  res.render 'ridestream', {
    layout: false
    locals: {
      fromKey: fromKey
      toKey: toKey
    }
  }