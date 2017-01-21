#!/usr/bin/env bundle exec rackup

# This is just for development. It compiles posts
# and serves static files from the output/ directory.

require "ace"
require "./boot"

use Rack::Head

class Server
  def initialize(root)
    @file_server = Rack::File.new(root)
  end

  def call(env)
    path = env["PATH_INFO"]
    status, headers, body = self.serve(env)

    if status == 404 && env["PATH_INFO"].end_with?("/")
      env["PATH_INFO"] = File.join(env["PATH_INFO"], "index.html")
      status, headers, body = self.serve(env)
    elsif status == 404
      log "[404]", env["PATH_INFO"]
      env["PATH_INFO"] = "/404.html"
      status, headers, body = self.serve(env)
    end

    return [status, headers, body]
  end

  protected
  def serve(env)
    base, slug = File.split(env["PATH_INFO"])
    self.compile(slug) if base == "/posts"
    @file_server.call(env)
  end

  def compile(slug)
    if path = get_post_source(slug)
      log "Compiling", path

      compile_time = timer { raw_compile(path) }

      log "Compile time", compile_time
    end
  end

  # Stolen from bin/ace. This should be part of the API.
  # This code is based on two assumptions: the file has
  # metadata and it could be instantiated as a Post object.
  def raw_compile(path)
    raw_item = Ace::RawItem.new(path).tap(&:parse)
    item = Post.create(raw_item.metadata, raw_item.content, path)
    item.save!
  end

  def get_post_source(slug)
    Dir["drafts/#{slug}", "content/posts/*-#{slug}"].first
  end

  def timer(&block)
    start_time = Time.now
    block.call
    Time.now - start_time
  end

  def log(bold, message)
    warn "~ \033[1;31m#{bold}\033[0m #{message}"
  end
end

run Server.new("output")
