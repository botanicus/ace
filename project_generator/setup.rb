# encoding: utf-8

# This hook will be executed in context of current generator object before templater start to generate new files.
# You can update context hash and register hooks. Don't forget to use merge! instead of merge, because you are
# manipulating with one object, rather than returning new one.

# ace-gen project --user="Jakub Stastny" --name=101Ideas.cz --url=http://101ideas.cz

hook do |generator, context|
  context[:user] ||= ENV["USER"]
  context[:name] || raise("You have to specify at least --title=WebTitle")
  context[:url] ||= "http://#{context[:name]}"
end
