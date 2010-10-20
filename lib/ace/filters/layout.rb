# encoding: utf-8

require "ace/filters"
require "template-inheritance"

TemplateInheritance::Template.paths << File.join(Dir.pwd, "layouts")

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
