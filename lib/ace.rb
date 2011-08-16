# encoding: utf-8

# === The boot process === #
# 1) load the app
# 2) load the rules (controllers / globs mapping)
# 3) load & instantiate all the renderable items
# 4) render all the items (here the filters & layouting run)
# 5) match the routes, write the files

require "yaml"
require "fileutils"
require "ace/filters/sass"
require "digest/sha1"
require "date"

module Ace
  module Helpers
    # include your helpers here
  end

  class RawItem
    attr_accessor :path, :metadata, :content
    def initialize(path)
      @path = path
      @data = File.read(path)
    end

    def parse
      pieces = @data.split(/^-{3,5}\s*$/)
      if pieces.length == 1 || @data.empty?
        self.metadata = Hash.new
        self.content  = pieces.first
      else
        self.metadata = begin
          YAML.load(pieces[1]).inject(Hash.new) { |metadata, pair| metadata.merge(pair[0].to_sym => pair[1]) } || Hash.new
        end
        self.content = pieces[2..-1].join.strip
      end

      set_timestamps_in_metadata
    end

    private
    def set_timestamps_in_metadata
      self.metadata[:created_at] ||= File.ctime(self.path)
      self.metadata[:updated_at] ||= File.mtime(self.path)
    end
  end

  # This class represents the items which will be
  # eventually rendered like concrete posts, tags etc.
  class Item
    def self.inherited(subclass)
      self.subclasses << subclass

      self.before_filters.each do |instance|
        subclass.before_filters << instance.dup
      end

      self.after_filters.each do |instance|
        subclass.after_filters << instance.dup
      end
    end

    def self.subclasses
      @subclasses ||= [self]
    end

    def self.instances
      @instances ||= Array.new
    end

    def self.all_subclasses
      self.subclasses + self.subclasses.map(&:subclasses).flatten
    end

    def self.all_instances
      self.all_subclasses.map(&:instances).flatten
    end

    def self.before_filters
      @before_filters ||= Array.new
    end

    def self.before(filter, *args)
      self.before_filters << filter.new(*args)
    end

    def self.after_filters
      @after_filters ||= Array.new
    end

    def self.after(filter, *args)
      self.after_filters << filter.new(*args)
    end

    def self.create(*args)
      self.new(*args).tap(&:register)
    end

    # Content can be anything, not just a string.
    attr_accessor :metadata, :content
    attr_accessor :original_path
    def initialize(metadata, content, original_path)
      @metadata      = metadata
      @content       = content
      @original_path = original_path
    end

    def config
      @config ||= begin
        YAML::load_file("config.yml").inject(Hash.new) do |hash, pair|
          hash.merge!(pair[0].to_sym => pair[1])
        end
      end
    end

    def register
      instances = self.class.instances
      unless instances.include?(self)
        self.class.instances << self
      end
    end

    def unregister
      self.class.instances.delete(self)
    end

    def render
      output = self.class.before_filters.inject(self.content) do |buffer, filter|
        filter.call(self, buffer)
      end

      self.class.after_filters.inject(output) do |buffer, filter|
        filter.call(self, buffer)
      end
    end

    def server_path
      absolute = self.output_path.sub(/^output\//, "")
      "/#{absolute}"
    end

    def base_url
      self.config[:base_url]
    end

    def permalink
      if self.config[:base_url].nil?
        raise "You have to add :base_url into config.yml or redefine #base_url method!"
      end

      "#{self.base_url}#{self.server_path}"
    end

    def digest(data)
      Digest::SHA1.hexdigest(data)
    end

    attr_writer :output_path
    def output_path
      @output_path ||= begin
        unless self.original_path.nil?
          self.original_path.sub("content", "output")
        end
      end
    end

    def save!
      puts "~ [RENDER] #{self.output_path}"
      content = self.render # so filters can influence output_path

      begin
        old_content = File.open(self.output_path, "rb") { |f| f.read }
      rescue
        old_content = ''
      end

      if self.digest(content) != self.digest(old_content)
        warn "~ CRC isn't same, save new content into #{self.output_path}"
        # puts old_content.inspect
        # puts content.inspect

        FileUtils.mkdir_p File.dirname(self.output_path)
        File.open(self.output_path, "w") do |file|
          file.puts(content)
        end
      end
    end
  end

  class Asset < Item
    before Ace::SassFilter
  end
end
