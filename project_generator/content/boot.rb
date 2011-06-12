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

# Load the app.
Dir["app/**/*.rb"].each do |file|
  puts "~ Loading #{file}"
  load file
end
