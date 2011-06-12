#!/usr/bin/env rackup

# This is just for development. The only thing it does
# is serving of static files from the output/ directory.

use Rack::Head

class Server
  def initialize(root)
    @file_server = Rack::File.new(root)
  end

  def call(env)
    path = env["PATH_INFO"]
    returned = @file_server.call(env)
    if returned[0] == 404 && env["PATH_INFO"].end_with?("/")
      env["PATH_INFO"] = File.join(env["PATH_INFO"], "index.html")
      returned = @file_server.call(env)
      log "[404]", env["PATH_INFO"] if returned[0] == 404
      returned
    else
      returned
    end
  end

  private
  def log(bold, message)
    warn "~ \033[1;31m#{bold}\033[0m #{message}"
  end
end

run Server.new("output")
