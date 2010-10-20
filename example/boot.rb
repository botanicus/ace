#!/usr/bin/env ace
# encoding: utf-8

Dir["app/**/*.rb"].each do |file|
  load file
end
