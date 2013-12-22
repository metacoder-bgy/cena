request = require 'requestify'
QUERY_COOKIE_URL = 'http://bgy.gd.cn/mis/info/menu_info.asp?type=%D1%A7%C9%FA%CD%F8%D2%B3'

exports.start = (req, res) ->
  request.get(QUERY_COOKIE_URL).then (response) ->
    res.send response.getHeader 'set-cookie'

exports.check = (req, res) ->
  setTimeout ->
    res.send result: 'pending...'
  , 2000