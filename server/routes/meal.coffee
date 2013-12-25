async = require 'async'
request = require 'request'
buffertools = require 'buffertools'
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
    str: '\xCE\xDE\xCC\xF5\xD0\xCE\xC2\xEB\x21\x21'
    msg: 'Please Submit Card Number'
    code: '0002'
  }
  {
    str: '\xc3\xdc\xc2\xeb\xbb\xf2\xcc\xf5\xd0\xce\xc2\xeb\xb4\xed\xce\xf3\x21\x21'
    msg: 'Wrong Password'
    code: '0003'
  }
]

fields = {}
for i in [1..5]
  for j in 'bc'.split ''
    fields["D#{i}#{j}"] = '11'
    fields["D#{i}#{j}j"] = 'A'

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
        # res.type 'html'
        # return res.send body
        for e in errcode
          console.log body, e.str
          console.log body.toString()
          if buffertools.indexOf(body, e.str) >= 0
            return res.send e
        callback null, cookies

    # get week list
    (cookies, callback) ->
      request URIs.booking,
        jar: cookies
        encoding: null
      , (err, response, body) ->
        # res.send body
        callback null, cookies, body
        .toString()
        .match(/20\d{7}/g)
        .filter (v,i,s) ->
          s.indexOf(v) == i

    # book meal
    (cookies, week_list, callback) ->
      body =
        hd: '001'
        size: 'A'
        B1: '\xb1\xa3\xb4\xe6'
      for k, v of fields
        body[k] = v
      for w in week_list
        body.m_date = w
        request.post URIs.booking,
          headers:
            'content-type': 'application/x-www-form-urlencoded'
          body: stringify body
          jar: cookies
          encoding: null
        , (err, response, body) ->
          res.send body
  ]

exports.check = (req, res) ->
  request.get(URIs.cookies).then (response) ->
    res.send response.getHeader 'set-cookie'