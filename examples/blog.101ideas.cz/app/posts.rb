# encoding: utf-8

require "nokogiri"
require "ace/filters/template"
require "ace/filters/pygments"
require "ace/filters/image_thumbnailer"
require "ace/filters/gravatar"
require "ace/mixins/lazy"
require "time"
require "date" # Date#stftime

# Inheritted methods:
#   - content
#   - metadata
#   - config

# /:posts/:slug
class Post < Blog
  include Ace::LazyRendering

  before Ace::TemplateFilter, layout: "post.html"
  before Ace::PygmentsFilter
  before Ace::ImageThumbnailerFilter
  #before Ace::GravatarFilter

  def output_path
    dir, base = File.split(super)
    slug = base.sub(/^\d{4}-\d{2}-\d{2}-(.+)$/, '\1')
    File.join(dir, slug)
  end

  def title
    slug = (self.in_series? ? "#{self.series_title}: " : '')
    "#{slug}#{self.metadata[:title]}"
  end

  def initialize(metadata, content, original_path)
    super
    year, month, day = File.basename(original_path).slice(0, 10).split("-")
    metadata[:created_at] = Date.new(year.to_i, month.to_i, day.to_i)
    metadata[:updated_at] = metadata[:updated_at].to_date
  end

  def self.posts
    Post.instances.sort do |post, another|
      another.metadata[:created_at] <=> post.metadata[:created_at]
    end
  end

  def feeds
    super + self.tags.
      map { |tag| TagFeed.new(tag) }
  end

  def self.series
    series_posts = self.posts.select do |post|
      post.metadata[:series]
    end.

    inject(Hash.new) do |slug, post|
      key = post.metadata[:series]
      slug[key] ||= Array.new
      slug[key] << post
      slug
    end.

    each do |key, series|
      series.sort! { |a,b| a.metadata[:created_at] <=> b.metadata[:created_at] }
    end
  end

  def in_series?
    !self.metadata[:series].nil?
  end

  def series
    Post.series[self.series_title]
  end

  def series_title
    self.metadata[:series]
  end

  def series_index
    self.series.index(self)
  end

  def series_size
    self.series.size
  end

  def has_previous?
    self.series_index > 0
  end

  def has_next?
    (self.series_index + 1) < self.series_size
  end

  def previous_part
    self.series[self.series_index - 1]
  end

  def next_part
    self.series[self.series_index + 1]
  end

  def document
    Nokogiri::HTML(self.content)
  end

  def excerpt
    paragraph = self.document.css("p#excerpt")
    paragraph.remove_attr("id")
    paragraph
  end

  def rss_excerpt
    self.excerpt.inner_text
  end

  def pub_date
    self.metadata[:created_at]
  end

  def updated?
    self.pub_date != self.updated_at
  end

  def updated_at
    @updated_at ||= File.mtime(self.original_path).to_date
  end

  def pub_date_RFC822
    pub_date.rfc822
  end

  # For Ace::LazyRendering#fresh?
  def source_files
    super + ["layouts/post.html.haml", "layouts/base.html.haml"] + Dir["layouts/_*"]
  end

  def tags
    self.metadata[:tags].map do |tag_name|
      Tag.new(tag_name, [self])
    end
  end

  def has_tags?
    not self.metadata[:tags].empty?
  end

  def tag_list
    self.tags.map do |tag|
      Helpers::Tag.new(:a, href: tag.server_path) { |a| a.content << tag.name }
    end
  end
end
