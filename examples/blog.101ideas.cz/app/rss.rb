# encoding: utf-8

require "ace/filters/template"
require "date"

class RSSFeed < Ace::Item
  # Render self.original_path as a template.
  # Original path is the second argument we pass to the rule:
  # rule Tags, "tags.html.haml"
  before Ace::TemplateFilter

  def title
    "All Posts"
  end

  def posts
    Post.posts
  end

  def posts_limited(limit = 20)
    self.posts.slice(0, limit)
  end

  # When we published the feed. If we'd use Time.now,
  # it'd keep changing all the time, which is annoying
  # in Git. Considering the fact that we don't really
  # use time, but date in posts, it makes sense to
  # update this just once per day.
  def pub_date
    Date.today
  end

  def pub_date_RFC822
    self.pub_date.rfc822
  end

  def output_path
    "output/posts.rss"
  end

  def to_html_link
    Helpers::Tag.new(:a, class: "rssfeed", href: self.server_path) { |tag| tag.content << self.title }
  end

  def to_html_autodiscovery_link
    Helpers::SelfCloseTag.new(:link, title: "Blog 101Ideas.cz: #{self.title}", href: self.server_path, rel: "alternate", type: "application/rss+xml")
  end
end

class TagFeed < RSSFeed
  def self.generate
    Tag.tags.each do |tag|
      self.new(tag).register
    end
  end

  def initialize(tag)
    @tag = tag
  end

  def title
    @tag.name
  end

  def posts
    @tag.posts
  end

  # The template filter requires it.
  def original_path
    "content/feed.rss.haml"
  end

  def output_path
    "output/rss/#{@tag.slug}.rss"
  end
end
