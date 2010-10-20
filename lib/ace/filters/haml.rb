# encoding: utf-8

require "haml"
require "ace/filters"

module Ace
  class HamlFilter < Filter
    # http://haml.hamptoncatlin.com/docs/rdoc/classes/Haml/Engine.html
    def call(item, content)
      if item.output_path && item.output_path.end_with?(".haml")
        item.output_path.sub!(/\.haml$/, "")
      end

      engine = Haml::Engine.new(content)
      engine.render(item.extend(Ace::Helpers))
    end
  end
end
