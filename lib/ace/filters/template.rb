# encoding: utf-8

require "ace/filters"
require "template-inheritance"

module Ace
  class TemplateFilter < Filter
    class Scope
      include Ace::Helpers
    end

    def self.add_to_paths(directory)
      unless TemplateInheritance::Template.paths.include?(directory)
        TemplateInheritance::Template.paths.unshift(directory)
      end
    end

    def initialize(options = Hash.new)
      @path = options[:layout]
    end

    def call(item, content)
      if @path.nil?
        @path = item.original_path.sub("content/", "")
      end

      parts = item.output_path.split(".")
      if parts.length == 2 # template.haml
        item.output_path = "#{parts[0]}.html"
      elsif parts.length == 3 # template.html.haml or template.xml.haml
        item.output_path = "#{parts[0]}.#{parts[1]}"
      else
        raise "Template can be named either with one suffix as template.haml or with two of them as template.html.haml resp. template.xml.haml."
      end

      template = TemplateInheritance::Template.new(@path, Scope.new)
      return template.render(item: item)
    end
  end
end

Ace::TemplateFilter.add_to_paths(File.join(Dir.pwd, "layouts"))
Ace::TemplateFilter.add_to_paths(File.join(Dir.pwd, "content"))
