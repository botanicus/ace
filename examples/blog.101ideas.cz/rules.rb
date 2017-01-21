# encoding: utf-8

require "ace/static"

# filters
rule Post, "posts/*.html"
rule Ace::Asset, "robots.txt", "assets/**/*"

rule Static, "tags.html.haml"
rule Static, "about.html.haml"
rule Static, "series.html.haml"
rule Static, "404.html.haml"

# RSS
rule RSSFeed, "feed.rss.haml"

# generators
generator Tag
generator Series
generator TagFeed
generator PaginatedPosts
