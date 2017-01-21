// usage:
// window.addEvent("domready", function() {
//  new MooGitHub({username: 'botanicus', element: 'github-badge'});
// });

MooGitHub = new Class({
  Implements: Options,

  repos: [],

  options: {
    element: 'github-badge',
    max_items: 6,
    username: 'hotovson',
    url: 'http://github.com/api/v2/json/repos/show/',
  },

  initialize: function(options){
    this.setOptions(options);
    this.options.url = this.options.url + this.options.username;
    this.requestData();
  },

  requestData: function(){
    new Request.JSONP({
      element: this.options.element,
      url: this.options.url,
      items: this.options.max_items,

      onComplete: function(data){
        data.repositories.length < this.options.items ? slug = data.repositories.length : slug = this.options.items;

        this.repos = data.repositories.filter(
          function(item, index){
            return !item.fork;
          }).sort(
          function(a,b){
            if (b.pushed_at > a.pushed_at) return 1;
            if (b.pushed_at < a.pushed_at) return -1;
            return 0;
          }).splice(0, slug);

        ul = new Element('ul');
        this.repos.each(function(repo){
          li = new Element('li');
          new Element('a', {
            text: repo.name,
            href: repo.url
          }).inject(li);
          li.inject(ul);
        });

        if ($(this.options.element)) ul.inject($(this.options.element));
      }
    }).send();
  }
});
