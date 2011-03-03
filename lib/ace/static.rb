# encoding: utf-8

require "ace/filters/template"

# rule Ace::Static, "about.html.haml"
# rule Ace::Static("output/index.html"), "index.html.haml"
module Ace
  def self.Static(output_path)
    Class.new(Static) do
      define_method(:output_path) do
        output_path
      end
    end
  end

  class Static < Item
    before Ace::TemplateFilter
  end
end
