fs = require 'fs'
mongoose = require 'mongoose'
db = mongoose.createConnection 'localhost', 'like'

countSchema = mongoose.Schema {count: Number}
Count = db.model 'count', countSchema

imageSchema = mongoose.Schema {
  url: String,
  count: Number,
  unixTime: Number,
}
Image = db.model 'image', imageSchema

exports.index = (req, res) ->

  res.render 'index'
    req: req

exports.failed = (req, res) ->
  res.render '404'
    req: req

exports.upload = (req, res)->
  t = new Date()
  _count = 0;
  unixtime = Math.ceil t.getTime()/1000
  Count.find {}, (err, data)->
    _count = data[0].count
    _count++
    Count.update {_id:data[0]._id}, {$set: {count:_count}}, (err,d)->
      if err
        console.log err
  fs.readFile req.files.image.path, (err, data)->
    newPath = "./public/images/like/"+_count+".jpg"
    fs.writeFile newPath,data, (err, data)->
      if err
        console.log err
      console.log 'saved!'
      image = new Image()
      image.url = "http://localhost:1218/images/like/"+_count+".jpg"
      image.count = _count
      image.time = new Date()
      image.save (err)->
        if err
          console.log err
        return res.json {status: "OK"}

exports.initImages = (req,res)->
  res.contentType "application/json"
  res.header("Access-Control-Allow-Origin", "*");

  Image.find({}).sort({count: "descending"}).exec (err, images)->
    console.log images
    res.json images
  ###
  json = []
  imagesDir = fs.readdirSync "./public/images/like/"
  imagesDir = imagesDir.sort()
  for key in imagesDir
    json.push "http://133.27.247.69:1217/images/like/"+key
  res.json json
  ###
exports.latestImages = (req, res)->
  res.contentType "application/json"
  res.header("Access-Control-Allow-Origin", "*");
  Image.find({}).sort({count: "descending"}).limit(req.params.num).exec((err, images)->
    console.log images
    res.json images
  )

exports.images = (req,res)->
  res.contentType "application/json"
  res.header("Access-Control-Allow-Origin", "*");
  count = Count.find {}, (err, data)->
    return data[0].count
  Image.find({}).where("count").gt(req.params.start).limit(req.params.num).exec((err, data)->
    res.json data
  )
exports.allImages = (req, res)->
  res.contentType "application/json"
  res.header("Access-Control-Allow-Origin", "*");
  Image.find({}).sort({count: "descending"}).exec (err, images)->
    console.log images
    res.json images

exports.initializeImage = (req, res)->
  res.contentType "application/json"
  res.header "Access-Control-Allow-Origin", "*"
  Image.remove {}, (err)->
    if err
      res.json err
    else
      console.log "reset"
      res.json {}


exports.countUp = (req,res)->
  res.contentType "application/json"
  res.header "Access-Control-Allow-Origin", "*"

  Count.find {}, (err, data)->
    if err
      return res.json err
    _count = data[0].count
    _count++
    Count.update {_id: data[0]._id}, {$set: {count: _count}}, (err, d)->
      if err
        return res.json err
      res.json {count: _count}

exports.countSet = (req, res)->
  res.contentType "application/json"
  res.header "Access-Control-Allow-Origin", "*"

  Count.find {}, (err, data)->
    if err
      return res.json err
    _count = req.params.count
    Count.update {_id: data[0]._id}, {$set: {count: _count}}, (err, d)->
      if err
        return res.json err
      return res.json {count: _count}


exports.inititalizeCount = (req,res)->
  res.contentType "application/json"
  res.header "Access-Control-Allow-Origin", "*"
  Count.remove {}, (err)->
    if err
      res.json err
    else
      console.log "reset"
      count = new Count {count: 0}
      count.save (err)->
        if err
          return res.json err
        res.json {count: 0}
