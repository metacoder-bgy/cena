var Card, CardList,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  _this = this;

this.Card = Card = (function() {
  function Card(parent, num, pass) {
    var tmpl,
      _this = this;
    this.parent = parent;
    this.num = num != null ? num : '';
    this.pass = pass != null ? pass : '';
    this.go = __bind(this.go, this);
    this.remove = __bind(this.remove, this);
    this.getPass = __bind(this.getPass, this);
    this.getNum = __bind(this.getNum, this);
    tmpl = _.template($('#tmpl-card').html());
    this.$el = $(tmpl({
      num: this.num,
      pass: this.pass
    }))[0];
    $('.btn-remove', this.$el).click(function() {
      _this.remove();
      return false;
    });
    this.parent.append(this.$el);
  }

  Card.prototype.getNum = function() {
    return $('.card-num', this.$el).val();
  };

  Card.prototype.getPass = function() {
    return $('.card-pass', this.$el).val();
  };

  Card.prototype.remove = function() {
    if (this.parent.length() <= 1) {
      return;
    }
    this.parent.remove(this);
    return this.$el.remove();
  };

  Card.prototype.go = function() {};

  return Card;

})();

this.CardList = CardList = (function() {
  function CardList($el) {
    this.$el = $el;
    this.remove = __bind(this.remove, this);
    this.indexOf = __bind(this.indexOf, this);
    this.length = __bind(this.length, this);
    this.append = __bind(this.append, this);
    this.add = __bind(this.add, this);
    this.list = new Array();
  }

  CardList.prototype.add = function(num, pass) {
    return this.list.push(new Card(this, num, pass));
  };

  CardList.prototype.append = function(el) {
    return this.$el.append(el);
  };

  CardList.prototype.length = function() {
    return this.list.length;
  };

  CardList.prototype.indexOf = function(card) {
    return this.list.indexOf(card);
  };

  CardList.prototype.remove = function(index) {
    if (typeof index === 'object') {
      index = this.indexOf(index);
    }
    if (index >= 0) {
      return this.list.splice(index, 1);
    }
  };

  return CardList;

})();

$(document).ready(function() {
  _this.cardList = new CardList($('#form-table'));
  cardList.add();
  return $('.btn-add').click(function() {
    cardList.add();
    return false;
  });
});
