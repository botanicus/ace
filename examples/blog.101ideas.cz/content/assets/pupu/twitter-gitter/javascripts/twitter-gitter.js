// This is based on David Walsh's code,
// I upgraded it for Request.JSONP of MooTools
// More and I've done some minor adjustments.
var TwitterGitter = new Class({

  // implements
  Implements: [Options, Events],

  // options
  options: {
    count: 2,
    sinceID: 1,
    link: true,
    onRequest: $empty,
    onComplete: $empty
  },

  // initialization
  initialize: function (username, options) {
    this.setOptions(options);
    this.info = {};
    this.username = username;
  },

  // get it!
  retrieve: function () {
    new Request.JSONP({
      url: "http://twitter.com/statuses/user_timeline/" + this.username + ".json",
      data: {
        count: this.options.count,
        since_id: this.options.sinceID
      },
      onRequest: this.fireEvent("request"),
      onSuccess: function(data) {
        // linkify?
        if(this.options.link) {
          data.each(function(tweet) {
            tweet.text = this.linkify(tweet.text);
          }, this);
        }
        // complete!
        this.fireEvent("complete", [data, data[0].user]);
      }.bind(this)
    }).send();

    return this;
  },

  // format
  linkify: function(text) {
    // courtesy of Jeremy Parrish (rrish.org)
    return text.replace(/(https?:\/\/\S+)/gi, '<a href="$1">$1</a>').replace(/(^|\s)@(\w+)/g, '$1<a href="http://twitter.com/$2">@$2</a>').replace(/(^|\s)#(\w+)/g, '$1#<a href="http://search.twitter.com/search?q=%23$2">$2</a>');
  }
});
