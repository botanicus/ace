# encoding: utf-8

require_relative "template"

warn "~ LayoutFilter is deprecated, use TemplateFilter from now on."

module Ace
  class LayoutFilter < TemplateFilter
  end
end
