# encoding: utf-8

require "ace/filters"
require "nokogiri"

module Ace
  class ImageThumbnailerFilter < Filter
    def thumb_name(filename)
      filename.gsub(/\.([^\.]*)$/, '_thumb.\1')
    end

    def thumbnail_nodeset(filename, doc)
      a = Nokogiri::XML::Node.new 'a', doc
      img = Nokogiri::XML::Node.new 'img', doc
      a.set_attribute('href', filename)
      img.set_attribute('src', thumb_name(filename))
      img.parent = a
      a
    end
    
    def make_thumbnail_image(filename, size)
      size ||= 20   # default size
      cmd = "convert content#{filename} -resize #{size} content#{thumb_name(filename)}"
      warn "~ make thumbnail with '#{cmd}'"
      system(cmd)
      raise "Error when converting image 'content#{filename}'" if $?.to_i != 0
    end

    def call(item, content)
      puts item.inspect
      doc = Nokogiri::HTML(content)
      doc.css("thumbnail").each do |thumb|
        make_thumbnail_image thumb[:src], thumb[:size]
        thumb.replace thumbnail_nodeset(thumb[:src], doc)
      end
      doc.to_s
    end
  end
end
