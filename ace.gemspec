#!/usr/bin/env gem build
# encoding: utf-8

require "base64"
require File.expand_path("../lib/ace/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "ace"
  s.version = Ace::VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/ace"
  s.summary = "Ace is highly flexible static pages generator with template inheritance."
  s.description = "" # TODO: long description
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n")

  s.executables = Dir["bin/*"].map(&File.method(:basename))
  s.default_executable = "ace"
  s.require_paths = ["lib"]

  # Dependencies
  # RubyGems has runtime dependencies (add_dependency) and
  # development dependencies (add_development_dependency)
  # Ace isn't a monolithic framework, so you might want
  # to use just one specific part of it, so it has no sense
  # to specify dependencies for the whole gem. If you want
  # to install everything what you need for start with Ace,
  # just run gem install ace --development

  s.add_dependency "template-inheritance"
  s.add_development_dependency "simple-templater", ">= 0.0.1.2"

  begin
    require "changelog"
  rescue LoadError
    warn "You have to have changelog gem installed for post install message"
  else
    s.post_install_message = CHANGELOG.new.version_changes
  end

  # RubyForge
  s.rubyforge_project = "ace"
end
