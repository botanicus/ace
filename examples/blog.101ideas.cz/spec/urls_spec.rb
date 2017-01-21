# encoding: utf-8

require "spec_helper"

describe "blog urls" do
  describe "assets" do
    server_path_should_exist "/assets/css/stylesheet.css"
  end

  describe "static pages" do
    server_path_should_exist "/index.html"
    server_path_should_exist "/about.html"
    server_path_should_exist "/tags.html"
  end

  describe "RSS feeds" do
    server_path_should_exist "/posts.rss"
    server_path_should_exist "/rss/it.rss"
    server_path_should_exist "/rss/self-development.rss"
  end

  describe "posts" do
    server_path_should_exist "/posts/blog-reloaded.html"
  end

  describe "tags" do
    server_path_should_exist "/tags/ruby-1-9.html"
    server_path_should_exist "/tags/javascript.html"
  end
end
