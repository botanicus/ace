# encoding: utf-8

# filters
rule Post, "posts/*.html"
rule Ace::Asset, "assets/**/*"

# generators
generator Tag#, "/tags/:slug"
