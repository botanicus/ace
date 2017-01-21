#!/usr/bin/env bundle exec nake
# encoding: utf-8

Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"

# Task.tasks.default_proc = lambda { |*| Task[:generate] }

Task.new(:tags) do |task|
  task.description = "Show available tags."

  task.define do
    ARGV.clear.push("--no-generate")
    load `which ace`.chomp
    puts
    Tag.tags_by_occurrence.each do |tag|
      puts "#{tag.name} (#{tag.posts.size})"
    end
  end
end

Task.new(:publish) do |task|
  task.description = "Publish given draft."

  task.define do |draft_path|
    date = Time.now.strftime("%Y-%m-%d")
    slug = File.basename(draft_path)
    path = "content/posts/#{date}-#{slug}"

    sh "mv #{draft_path} #{path}"
    sh "git rm #{draft_path} 2> /dev/null"
    sh "git add #{path}"
    Task[:regenerate].call
    sh "git add output"
    sh "git commit #{path} output/ -m '[POST] #{slug} published.'"
  end
end

Task.new(:generate) do |task|
  task.description = "Generate static HTML."

  task.define do
    sh "./boot.rb"
  end
end

Task.new(:clobber) do |task|
  task.description = "Remove all generated files."

  # This won't rewrite the git repo.
  task.define do
    sh "rm -rf output/*"
  end
end

Task.new(:regenerate) do |task|
  task.description = "Remove all generated files and generate them again."

  task.dependencies << :clobber
  task.dependencies << :generate
end

Task.new(:commit) do |task|
  task.description = "Regenerate all generated files and commit them."
  task.dependencies << :regenerate

  task.define do
    Dir.chdir("output") do
      sh "git add ."
      sh "git commit -a -m '#{Time.now.stftime("%H:%M %d/%m/%Y")}'"
    end
  end
end
