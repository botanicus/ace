# encoding: utf-8

require "ace/filters/template"

# /tags/:slug
class Tag < Blog
  before Ace::TemplateFilter, layout: "tag.html"

  # Tag class works as a generator, whereas Tag class
  # instances work as a representation of a single tag page.
  def self.generate
    self.tags.each do |tag|
      tag.register
    end
  end

  def self.posts_for(tag)
    Post.instances.select do |post|
      post.metadata[:tags].include?(tag)
    end
  end

  def self.tag_list
    Post.instances.reduce(Array.new) do |buffer, post|
      post.metadata[:tags].each do |tag|
        buffer << tag unless buffer.include?(tag)
      end
      buffer
    end
  end

  def self.tags
    self.tag_list.inject(Array.new) do |buffer, tag_name|
      buffer << Tag.new(tag_name, self.posts_for(tag_name))
    end
  end

  def self.tags_by_occurrence
    self.tags.sort do |tag, another|
      another.posts.size <=> tag.posts.size
    end
  end

  def self.tag_cloud
    self.tags_by_occurrence.reduce(String.new) do |buffer, tag|
      "#{buffer}\n<a href='#{tag.server_path}'>#{tag.name}</a>"
    end
  end

  # def self.output_path
  #   "output/tags.html"
  # end

  attr_reader :name, :posts
  def initialize(name, posts)
    @name, @posts = name, posts
  end

  def feeds
    [*super, TagFeed.new(self)]
  end

  def slug
    self.name.downcase.gsub(/[ .]/, "-")
  end

  def output_path
    "output/tags/#{self.slug}.html"
  end
end
