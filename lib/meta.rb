#!/usr/bin/env ruby

require "colorize"
require "digest/md5"
require "haml"
require "highline/import"
require "open3"
require "redcarpet"
require "sequel"
require "sqlite3"
require "thor"
require "tilt"

require File.join( File.dirname(__FILE__), "meta", "catalog" )
require File.join( File.dirname(__FILE__), "meta", "cli" )
require File.join( File.dirname(__FILE__), "meta", "filelib" )
require File.join( File.dirname(__FILE__), "meta", "page" )
require File.join( File.dirname(__FILE__), "meta", "version" )

# macro-like used to keep haml compatibility
def haml(file)
  return Tilt.new("#{file}.haml").render
end

module Meta

  BASEDIR         = ".".freeze
  DATASTORE       = File.join( Dir.pwd, "site.sqlite3" )
  EXCLUDES        = [ "layout.haml", "navbar.haml", "footer.haml" ]
  FEXISTS         = "File already exists".freeze
  HAML            = ["*.haml"]
  HAMLEXT         = ".haml".freeze
  HTML            = ["*.html"]
  HTMLEXT         = ".html".freeze
  INDEX           = "index.html".freeze
  MARKDOWN        = ["*.md", "*.markdown", "*.mkd"]
  MDEXT           = ".md".freeze
  PNGEXT          = ".png".freeze
  SEED            = 1234562
  SLASH           = "/".freeze
  SPACE           = " ".freeze

end

