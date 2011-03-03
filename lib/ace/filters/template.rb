# encoding: utf-8

require "ace/filters"
require "template-inheritance"

layouts = File.join(Dir.pwd, "layouts")
unless TemplateInheritance::Template.paths.include?(layouts)
  TemplateInheritance::Template.paths.unshift(layouts)
end

TemplateInheritance::Template.paths << File.join(Dir.pwd, "content")

module Ace
  class TemplateFilter < Filter
    TEMPLATE_EXTS_PATTERN = /\.(haml|erb|erubis)$/i

    def call(item, content)
      if item.output_path.match(TEMPLATE_EXTS_PATTERN)
        item.output_path = item.output_path.split(".")[0..-2].join(".")
      end

      relative_path = item.original_path.sub("content/", "")
      template = TemplateInheritance::Template.new(relative_path)
      return template.render(item: item)
    end
  end
end
