#!/usr/bin/env ruby

require "colorize"
require "digest/md5"
require "haml"
require "highline/import"
require "redcarpet"
require "sequel"
require "sqlite3"
require "thor"
require "tilt"

require File.join( File.dirname(__FILE__), "metc", "catalog" )
require File.join( File.dirname(__FILE__), "metc", "cli" )
require File.join( File.dirname(__FILE__), "metc", "filelib" )
require File.join( File.dirname(__FILE__), "metc", "page" )
require File.join( File.dirname(__FILE__), "metc", "version" )

# macro-like used to keep haml compatibility
def haml(file)
  return Tilt.new("#{file}.haml").render
end

module Metc

  BASEDIR         = ".".freeze
  COLS            = [ 1, 2, 2, 3, 4 ]
  DATASTORE       = File.join( Dir.pwd, "site.sqlite3" )
  EXCLUDES        = [ "layout.haml", "navbar.haml", "footer.haml" ]
  HAML            = ["*.haml"]
  HAMLEXT         = ".haml".freeze
  HTML            = ["*.html"]
  HTMLEXT         = ".html".freeze
  MARKDOWN        = ["*.md", "*.markdown", "*.mkd"]
  MARKDOWNEXT     = ".md".freeze
  SEED            = 1234

end

