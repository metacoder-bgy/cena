async = require 'async'
request = require 'request'
stringify = require('querystring').stringify

URIs =
  cookies: 'http://bgy.gd.cn/mis/info/menu_info.asp?type=%D1%A7%C9%FA%CD%F8%D2%B3'
  login: 'http://bgy.gd.cn/mis/info/list.asp'
  booking: 'http://bgy.gd.cn/mis/info/dc_info/dc3_new.asp'

errcode = [
  {
    str: '\xCD\xF8\xD2\xB3\xB9\xFD\xC6\xDA\x21\x21'
    msg: 'Cookie Expired'
    code: '0001'
  }
  {
    str: '\xCB\xCC\xF5\xD0\xCE\xC2\xEB\xC3\xBB\xD3'
    msg: 'Wrong Card Number'
    code: '0002'
  }
  {
    str: '\xCC\xF5\xD0\xCE\xC2\xEB\xB4\xED\xCE\xF3'
    msg: 'Wrong Password'
    code: '0003'
  }
]

fields = []
for i in [1..5]
  for j in 'bc'.split ''
    fields.push ["D#{i}#{j}", '11']
    fields.push ["D#{i}#{j}j", 'A']

exports.start = (req, res) ->
  async.waterfall [

    # get cookies
    (callback) ->
      cookies = request.jar()
      request URIs.cookies,
        jar: cookies
      , (err, response, body) ->
        callback null, cookies

    # perform login
    (cookies, callback) ->
      body =
        tbarno: req.param 'card'
        passwd: req.param 'pass'
        hd: '002'
        B1: '\xc8\xb7\xb6\xa8'
      request.post URIs.login,
        headers:
          'content-type': 'application/x-www-form-urlencoded'
        body: stringify body
        encoding: null
        jar: cookies
      , (err, response, body) ->
        res.type 'html'
        # res.send body
        callback null, cookies

    # book meals
    (cookies, callback) ->
      res.send cookies
  ]

exports.check = (req, res) ->
  request.get(URIs.cookies).then (response) ->
    res.send response.getHeader 'set-cookie'