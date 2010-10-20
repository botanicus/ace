#!/usr/bin/env gem build
# encoding: utf-8

eval(File.read("ace.gemspec")).tap do |specification|
  specification.version = "#{specification.version}.pre"
end
