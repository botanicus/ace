#!/usr/bin/env bundle exec nake
# encoding: utf-8

Task.new(:generate) do |task|
  task.description = "Generate static HTML."

  task.define do
    sh "./boot.rb"
  end
end
