# encoding: utf-8

require "sass"
require "ace/filters"

module Ace
  class SassFilter < Filter
    def call(item, content)
      if item.output_path && item.output_path.end_with?(".scss")
        item.output_path.sub!(/scss$/, "css")
        begin
          engine = Sass::Engine.new(content, {:syntax => :scss})
          output = engine.render
        rescue Exception => e
          warn "~~ SassFilter exception: #{e}"
          abort
        end
        return output
      else
        return content
      end
    end
  end
end