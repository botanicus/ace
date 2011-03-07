# encoding: utf-8

require "ace/filters"
require "nokogiri"
require "albino"

module Ace
  class PygmentsFilter < Filter
    def call(item, content)
      doc = Nokogiri::HTML(content)
      doc.css("pre[lang]").each do |pre|
        unless pre['lang'].nil? || pre['lang'].empty?
          # Set $VERBOSE to nil if you don't want to see this message.
          warn "~ Syntax highlight in '#{item.original_path}' using '#{pre['lang']}' lexer."
          pre.replace Albino.colorize(pre.content, pre['lang'])
        end
      end
      doc.to_s
    end
  end
end
