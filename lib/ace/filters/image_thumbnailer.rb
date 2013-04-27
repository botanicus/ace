# encoding: utf-8

require "ace/filters"
require "nokogiri"

# <thumbnail src="/assets/img/motivation-sheet.jpg" />
# <thumbnail src="/assets/img/motivation-sheet.jpg" size="550" />
# <thumbnail src="/assets/img/motivation-sheet.jpg" size="550x20" />

# TODO:
# class Post < Ace::Item
#   before Ace::ImageThumbnailerFilter, default_thumb_size: 550
# end

module Ace
  class ImageThumbnailerFilter < Filter
    def to_thumb(path)
      path.to_s.sub(/\.(\w+)$/, '_thumb.\1')
    end

    def thumbnail_nodeset(link, doc)
      link_node  = Nokogiri::XML::Node.new("a", doc)
      image_node = Nokogiri::XML::Node.new("img", doc)
      link_node.set_attribute("href", link)
      image_node.set_attribute("src", to_thumb(link))
      image_node.parent = link_node
      return link_node
    end

    def call(item, content)
      puts "~ [THUMB] #{item.original_path}"
      doc = Nokogiri::HTML(content)
      doc.css("thumbnail").each do |thumb|
        original_image_path = "content" + thumb[:src]
        thumbnail_path      = to_thumb("output"  + thumb[:src])
        generate_thumbnail(original_image_path, thumbnail_path, thumb[:src], thumb[:size] || 550)
        thumb.replace(thumbnail_nodeset(thumb[:src], doc))
      end
      doc.to_s
    end

    private
    def generate_thumbnail(original_path, thumbnail_path, link, size)
      unless File.exist?(thumbnail_path)
        command = "convert #{original_path} -resize #{size} #{thumbnail_path}"
        warn "~ $ #{command}"
        system(command)
        raise "Error when converting image '#{original_path}'" if $?.to_i != 0
      else
        warn "~ File #{thumbnail_path} already exists."
      end
    end
  end
end
