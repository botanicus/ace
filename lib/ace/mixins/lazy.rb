# encoding: utf-8

# Sometimes rendering is taking too long, so you want to skip
# it in case that nothing changed in the files which influence
# the output. For example syntax highlighting via Pygments takes
# a while, so it's better to include this mixin and redefine
# #source_files to include every file which influence the output.
module Ace
  module LazyRendering
    def compare_mtime(one, others)
      File.exist?(one) && File.mtime(one) > others.map { |post| File.mtime(post) }.max
    end

    # @api public
    def source_files
      [self.original_path]
    end

    def fresh?
      @fresh ||= compare_mtime(self.output_path, self.source_files)
    end

    def save!
      if self.fresh?
        puts "~ [IGNORE] #{self.output_path}"
      else
        super
      end
    end
  end
end
