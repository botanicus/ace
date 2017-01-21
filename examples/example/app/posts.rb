# encoding: utf-8

require "nokogiri"
require "ace/filters/template"

# Inheritted methods:
#   - content
#   - metadata
#   - config
class Post < Ace::Item
  before Ace::TemplateFilter, layout: "post.html"

  def document
    Nokogiri::HTML(self.content)
  end

  def excerpt
    self.document.css("p.excerpt")
  end
end
