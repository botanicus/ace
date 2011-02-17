# encoding: utf-8

require "ace/filters"
require "template-inheritance"

layouts = File.join(Dir.pwd, "layouts")
unless TemplateInheritance::Template.paths.include?(layouts)
  TemplateInheritance::Template.paths.unshift(layouts)
end

module Ace
  class LayoutFilter < Filter
    def initialize(options)
      @path = options[:layout]
    end

    def call(item, content)
      template = TemplateInheritance::Template.new(@path)
      return template.render(item: item)
    end
  end
end
