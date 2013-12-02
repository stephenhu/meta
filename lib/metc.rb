#!/usr/bin/env ruby

require "colorize"
require "haml"
require "redcarpet"
require "thor"
require "tilt"

require File.join( File.dirname(__FILE__), "metc", "cli" )
require File.join( File.dirname(__FILE__), "metc", "version" )

# macro-like used to keep haml compatibility
def haml(file)
  return Tilt.new("#{file}.haml").render
end

module Metc

  BASEDIR         = ".".freeze
  EXCLUDES        = [ "layout.haml", "navbar.haml", "footer.haml" ]
  HAML            = ".haml".freeze
  HTML            = ".html".freeze
  MARKDOWN        = ".md".freeze

end

