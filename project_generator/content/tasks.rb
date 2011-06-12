#!/usr/bin/env bundle exec nake
# encoding: utf-8

Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"

# Task.tasks.default_proc = lambda { |*| Task[:generate] }

Task.new(:generate) do |task|
  task.description = "Generate static HTML."

  task.define do
    sh "./boot.rb"
  end
end

Task.new(:rsync) do |task|
  task.description = "Rsync the output to server."

  # config
  task.config[:user]   = "TODO"
  task.config[:server] = "TODO"
  task.config[:path]   = "TODO"

  task.define do |options|
    sh "rsync -av --delete output/ #{config[:user]}@#{config[:server]}:#{config[:path]}"
  end
end
