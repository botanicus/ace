# encoding: utf-8

require_relative "posts"

# Inheritted methods:
#   - content
#   - metadata
#   - config

# /:posts/:slug
class PaginatedPosts < Blog
  PER_PAGE ||= 15

  def self.generate
    self.pages.each do |page|
      page.register
    end
  end

  def self.pages
    enumerator = Post.posts.each_slice(PER_PAGE)
    enumerator.reduce(Array.new) do |buffer, posts|
      buffer << self.new(posts, buffer.length + 1, enumerator.count)
    end
  end

  before Ace::TemplateFilter, layout: "index.html"

  attr_reader :posts, :page
  def initialize(posts, page, max)
    @posts, @page, @max = posts, page, max
  end

  def output_path
    if @page == 1
      "output/index.html"
    else
      "output/page/#{@page}.html"
    end
  end

  def previous_page
    @page + 1 unless @page == @max
  end

  def next_page
    @page - 1 unless @page == 1
  end

  def previous_page_path
    page_to_path(previous_page)
  end

  def next_page_path
    page_to_path(next_page)
  end

  protected
  def page_to_path(page)
    return if page.nil?
    page == 1 ? "/" : "/page/#{page}.html"
  end
end
