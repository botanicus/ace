# encoding: utf-8

require "ace/filters"
require "nokogiri"
require "albino"

module Ace
  class PygmentsFilter < Filter
    def call(item, content)
      puts 'PygmentsFilter ************************'
      doc = Nokogiri::HTML(content)
      doc.css('pre').each do |pre|
        puts "\nWARNING: '#{item.original_path}' - element <pre> not contains attribute 'lang'\n" if pre['lang'].nil?
        puts "\nWARNING: '#{item.original_path}' - attribute 'lang' not contains any value\n" if  !pre['lang'].nil? && pre['lang'].empty?
        puts "*** Syntax highlight using '#{pre['lang']}' lexer" unless pre['lang'].nil? || pre['lang'].empty?
        pre.replace Albino.colorize(pre.content, pre['lang']) unless pre['lang'].nil? || pre['lang'].empty?
      end
      doc
    end
  end
end
