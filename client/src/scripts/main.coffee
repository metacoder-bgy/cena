@Card = class Card
  constructor: (@parent, @card = '', @pass = '') ->
    tmpl = _.template $('#tmpl-line').html()
    @$el = $(tmpl card: @card, pass: @pass)[0]
    $('.button.icon-remove', @$el).click =>
      @remove()
      false
    $(@$el).hide()
    @parent.prepend @$el
    $(@$el).show 300
    unless @card or @pass
      $('.input-card', @$el).focus()
  addMessage: (icon, message, class) =>
    i = $("<icon class=\"icon-#{icon}\">")
    m = $("<span>").text message
  getNum: =>
    $('.input-card', @$el).val()
  getPass: =>
    $('.input-pass', @$el).val()
  remove: =>
    return if @parent.length() <= 1
    $(@$el).hide 300, =>
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
  prepend: (el) =>
    @$el.prepend el
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
  @cardList = new CardList $('#card-list')
  cardList.add()
  $('.button.add').click ->
    cardList.add()
    false
