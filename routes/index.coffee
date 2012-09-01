exports.index = (req, res) ->
  res.render 'index'
    req: req

exports.failed = (req, res) ->
  res.render '404'
    req: req
