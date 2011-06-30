# encoding: utf-8

require "ace/filters"
require "nokogiri"

# <thumbnail src="assets/img/motivation-sheet.jpg" />
# <thumbnail src="assets/img/motivation-sheet.jpg" size="550" />
# <thumbnail src="assets/img/motivation-sheet.jpg" size="550x20" />

# TODO:
# class Post < Ace::Item
#   before Ace::ImageThumbnailerFilter, default_thumb_size: 550
# end
module Ace
  class ImageThumbnailerFilter < Filter
    def thumb_path(file_name)
      @file_name ||= file_name
      @thumb_path ||= file_name.gsub(/\.([^\.]*)$/, '_thumb.\1')
    end

    def thumb_server_path
      @thumb_path.sub("content", "")
    end

    def original_image_server_path
      @file_name.sub("content", "")
    end

    def thumbnail_nodeset(file_name, doc)
      link  = Nokogiri::XML::Node.new("a", doc)
      image = Nokogiri::XML::Node.new("img", doc)
      link.set_attribute("href", original_image_server_path)
      image.set_attribute("src", thumb_server_path)
      image.parent = link
      return link
    end

    def call(item, content)
      puts "~ [THUMB] #{item.original_path}"
      doc = Nokogiri::HTML(content)
      doc.css("thumbnail").each do |thumb|
        original_file = "content/#{thumb[:src]}"
        generate_thumbnail(original_file, thumb[:size] || 550)
        thumb.replace(thumbnail_nodeset(original_file, doc))
      end
      doc.to_s
    end

    private
    def generate_thumbnail(file_name, size)
      unless File.exist?(thumb_path(file_name))
        command = "convert #{file_name} -resize #{size} #{thumb_path(file_name)}"
        warn "~ $ #{command}"
        system(command)
        raise "Error when converting image '#{file_name}'" if $?.to_i != 0
      else
        warn "~ File #{thumb_path(file_name)} already exists."
      end
    end
  end
end
