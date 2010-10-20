# encoding: utf-8

module Ace
  class DSL
    attr_accessor :rules, :generators
    def initialize
      @rules, @generators = Hash.new, Array.new
    end

    def rule(klass, *globs)
      paths = globs.map { |glob| Dir.glob("content/#{glob}") }
      files = paths.flatten.select { |path| File.file?(path) }
      self.rules[klass] ||= Array.new
      self.rules[klass].push(*files)
    end

    def generator(klass)
      self.generators << klass
    end
  end
end
