#!/usr/bin/env bundle exec ace
# encoding: utf-8

# Execute this file to generate the web.

Dir["app/**/*.rb"].each do |file|
  load file
end
