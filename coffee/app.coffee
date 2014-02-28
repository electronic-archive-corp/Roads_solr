connect = require("connect")
http = require("http")
path = require("path")
url = require("url")

options = {}
ipaddr = process.env.OPENSHIFT_INTERNAL_IP or "127.0.0.1"
port = process.env.OPENSHIFT_INTERNAL_PORT or 81

console.log "Server starting at http://" + ipaddr + ":" + port + "/"
console.log "Connecting to database..."

app = connect()
app.use connect.logger()
connect.logger
  immediate: true
  format: "dev"

app.use connect.json()
app.use connect.urlencoded()
app.use (req, res) ->
  try
    u = url.parse(req.url, true)
    if u and u.query and u.query.collection
      if u.pathname is "/get"
        getItems u, req, res
      else if u.pathname is "/update"
        updateItem u, req, res
      else if u.pathname is "/delete"
        deleteItems u, req, res
      else addItems u, req, res  if u.pathname is "/add"
      return
  catch ex
    console.log ex
    res.writeHead 200,
      "Content-Type": "text/plain"

    res.end "Database connection lost, try again later...\n"
    return
  res.writeHead 200,
    "Content-Type": "text/plain"

  res.end "Hello World\n"

addItems = (u, req, res) ->

updateItem = (u, req, res) ->
    collection = u.query.collection
    id = u.query.id
    item = req.body
    console.log "Updating item: " + id
    console.log JSON.stringify(item)


getItems = (u, req, res) ->
    collection = u.query.collection
    items = u.query.items.split(",")
    i = 0


deleteItems = (u, req, res) ->
    collection = u.query.collection
    id = u.query.items or req.body
    id = [id]  unless Array.isArray(id)
    console.log "Deleting item(s): " + id
    i = 0


http.createServer(app).listen port, ipaddr