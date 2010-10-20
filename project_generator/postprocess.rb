# encoding: utf-8

# This hook will be executed after templater finish in context of current generator object.
# Current directory is what you just generated, unless this is flat generator.

unless RUBY_PLATFORM.match(/mswin|mingw/)
  sh "chmod +x boot.rb"
  sh "chmod +x tasks.rb"
end
