# encoding: utf-8

require "ace/filters/template"

# /series/:slug
class Series < Blog
  # FIXME: why don't work with filename 'layouts/series.html.haml'?
  # possible collision with 'content/series.html.haml'
  before Ace::TemplateFilter, layout: "series-another-layout-file.html"

  # Series class works as a generator, whereas Series class
  # instances work as a representation of a single series page.
  def self.generate
    self.series.each do |series|
      series.register
    end
  end

  def self.posts_for(series)
    Post.instances.select do |post|
      post.metadata[:series] == series
    end.

    sort {|a,b| a.metadata[:created_at] <=> b.metadata[:created_at]}
  end

  def feeds # TODO: feed for serials
    super
  end

  def self.series_list
    Post.instances.inject(Array.new) do |buffer, post|
      buffer <<  post.metadata[:series]
    end.compact.uniq
  end

  def self.series
    self.series_list.inject(Array.new) do |buffer, series_name|
      buffer << Series.new(series_name, self.posts_for(series_name))
    end
  end

  attr_reader :name, :posts
  def initialize(name, posts)
    @name, @posts = name, posts
  end

  def slug
    self.name.downcase.gsub(" ", "-")
  end

  def output_path
    "output/series/#{self.slug}.html"
  end
end
