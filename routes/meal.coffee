exports.start = (req, res) ->
  setTimeout ->
    res.send result: 'ok'
  , 2000

exports.check = (req, res) ->
  setTimeout ->
    res.send result: 'pending...'
  , 2000