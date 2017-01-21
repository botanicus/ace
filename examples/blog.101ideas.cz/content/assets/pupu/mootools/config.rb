# javascripts for loading
javascript "mootools-1.2-core"

# parameters of plugin
# pupu :mootools, :more => true
parameter :more do |boolean|
  javascript "mootools-1.2-more" if boolean
end
