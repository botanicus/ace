# encoding: utf-8

require "ace/filters/template"

# rule Ace::Static, "about.html.haml"
module Ace
  class Static < Item
    before Ace::TemplateFilter
  end
end
