# encoding: utf-8

# The class represents all the tags, whereas
# the instance represents each single tag.
class Tag < Ace::Item
  before Ace::TemplateFilter, layout: "tag.html"

  def self.tags
    Post.instances.inject(Hash.new) do |buffer, post|
      if tags = post.metadata[:tags]
        tags.each do |tag|
          buffer[tag] ||= Array.new
          buffer[tag] << post
        end
      end
      buffer
    end
  end

  def self.generate
    self.tags.each do |tag_title, items|
      tag_name = tag_title.downcase.gsub(" ", "-")
      metadata = {title: tag_title, timestamp: Time.now}
      tag = Tag.create(metadata, items)
      tag.output_path = "output/tags/#{tag_name}.html"
    end
  end
end
