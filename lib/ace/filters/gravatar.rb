# encoding: utf-8

require 'digest/md5'
require 'nokogiri'

# <gravatar email="john@doe.com">

# TODO:
# class Post < Ace::Item
#   before Ace::GravatarFilter
# end

module Ace
  class GravatarFilter < Filter
    def gravatar_url(email)
      hash = Digest::MD5.hexdigest(email)
      "http://www.gravatar.com/avatar/#{hash}"
    end

    def call(item, content)
      doc = Nokogiri::HTML(content)
      doc.css("gravatar").each do |node|
        image_node = Nokogiri::XML::Node.new("img", doc)
        image_node.set_attribute("src", gravatar_url(node[:email]))
        node.replace(img)
      end
    end
  end
end
