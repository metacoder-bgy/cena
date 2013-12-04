@Card = class Card
  constructor: (@parent, @num = '', @pass = '') ->
    tmpl = _.template $('#tmpl-card').html()
    @$el = $(tmpl num: @num, pass: @pass)[0]
    $('.btn-remove', @$el).click =>
      @remove()
      false
    @parent.append @$el
  getNum: =>
    $('.card-num', @$el).val()
  getPass: =>
    $('.card-pass', @$el).val()
  remove: =>
    return if @parent.length() <= 1
    @parent.remove @
    @$el.remove()
  go: =>

@CardList = class CardList
  constructor: (@$el) ->
    @list = new Array()
  add: (num, pass) =>
    @list.push new Card @, num, pass
  append: (el) =>
    @$el.append el
  length: =>
    @list.length
  indexOf: (card) =>
    @list.indexOf card
  remove: (index) =>
    if typeof index == 'object'
      index = @indexOf index
    if index >= 0
      @list.splice index, 1

$(document).ready =>
  @cardList = new CardList $('#form-table')
  cardList.add()
  $('.btn-add').click ->
    cardList.add()
    false
