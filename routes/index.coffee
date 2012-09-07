fs = require 'fs'

exports.index = (req, res) ->

  res.render 'index'
    req: req

exports.failed = (req, res) ->
  res.render '404'
    req: req

exports.test = (req, res)->
  console.log req
  res.render 'index'
    req: req

exports.imagesjson = (req,res)->
  res.contentType "application/json"

  zerofill = (n)->
    if n<10
      return "0"+n
    else
      return n
  t = new Date()
  t.setTime req.params.time
  year    = zerofill(t.getYear())
  month   = zerofill(t.getMonth()+1)
  date    = zerofill(t.getDate())
  hours   = zerofill(t.getHours())
  minutes = zerofill(t.getMinutes())
  seconds = zerofill(t.getSeconds())

  count = 0
  photos = []
  endFlag = false
  requestTime = Number hours+minutes+seconds
  requestNum  = Number req.params.num
  imageDir = fs.readdirSync './public/images/2012/'+month+date
  if imageDir
    for file,i in imageDir
      hms = file.split "."
      fileTime = Number(hms[0])
      if fileTime >= requestTime && fileTime < requestTime+10
        count = i
        break
    for i in [0..requestNum]
      photos.push {url: "http://"+req.host+":3000"+"/images/2012/"+month+date+"/"+imageDir[count+i]}
    res.json photos

