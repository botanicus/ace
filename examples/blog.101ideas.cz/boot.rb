#!/usr/bin/env bundle exec ace
# encoding: utf-8

Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"

# Setup $LOAD_PATH.
require "bundler/setup"

# Custom setup.
require "pupu/adapters/ace"
Pupu.media_prefix = "/assets"

require "helpers"

class Blog < Ace::Item
  def feeds
    [RSSFeed.new(Hash.new, "", nil)]
  end
end

require "ace/filters/template"

class Static < Blog
  before Ace::TemplateFilter
end

# Load the app.
Dir["app/**/*.rb"].each do |file|
  puts "~ Loading #{file}"
  load file
end
