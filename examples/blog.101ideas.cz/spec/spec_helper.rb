# encoding: utf-8

require "bundler"

Bundler.setup

# macros
class StandardError
  attr_accessor :message
end

module Macros
  def server_path_should_exist(server_path)
    it "should have server path #{server_path}" do
      output_path = File.join("output", server_path)
      begin
        File.exist?(output_path).should be_true
      rescue RSpec::Expectations::ExpectationNotMetError => error
        error.message = "File '#{output_path}' doesn't exist!"
        raise error
      end
    end
  end
end

# configuration
RSpec.configure do |config|
  config.extend(Macros)

  # config.mock_with(nil) # doesn't work, what a shame!
  def config.configure_mock_framework
  end
end
