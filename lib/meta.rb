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
require "yaml"

require File.join( File.dirname(__FILE__), "meta", "catalog" )
require File.join( File.dirname(__FILE__), "meta", "cli" )
require File.join( File.dirname(__FILE__), "meta", "filelib" )
require File.join( File.dirname(__FILE__), "meta", "page" )
require File.join( File.dirname(__FILE__), "meta", "version" )

module Meta

  BASEDIR         = ".".freeze
  CONFIGFILE      = File.expand_path("~/.meta")
  DATASTORE       = File.join( Dir.pwd, "site.sqlite3" )
  EXCLUDES        = [ "layout.haml", "navbar.haml", "footer.haml" ]
  FEXISTS         = "File already exists".freeze
  FOOTER          = "footers/footer.haml".freeze
  FOOTERS         = "footers/*.haml".freeze
  HAML            = ["*.haml"]
  HAMLEXT         = ".haml".freeze
  HTML            = ["*.html"]
  HTMLEXT         = ".html".freeze
  INDEX           = "pages/index.haml".freeze
  LAYOUT          = "layouts/layout.haml".freeze
  LAYOUTS         = "layouts/*.haml".freeze
  MARKDOWN        = ["*.md", "*.markdown", "*.mkd"]
  MDEXT           = ".md".freeze
  NAVBAR          = "navbar/navbar.haml".freeze
  NAVBARS         = "navbars/*.haml".freeze
  PAGE            = "pages/page.haml".freeze
  PAGES           = "pages/*.haml".freeze
  PNGEXT          = ".png".freeze
  REQUIRED        = [ "index.haml", "layout.haml", "page.haml" ]
  SAMPLE          = "sample.md".freeze
  SEED            = 1234562
  SKELETONDIRS    = [ "footers", "layouts", "navbars", "pages" ]
  SLASH           = "/".freeze
  SPACE           = " ".freeze

  Sequel.extension :migration

end

