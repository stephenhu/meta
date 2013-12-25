module Metc

  class CLI < Thor
    include Thor::Actions

    desc( "compile", "compile meta files" )
    method_option :output, :aliases => "-o", :type => :string,
      :required => false, :desc => "static file output directory"
    method_option :exclude, :aliases => "-e", :type => :string,
      :required => false, :desc => "comma separated list"
    method_option :force, :aliases => "-f", :type => :boolean,
      :required => false, :desc => "don't prompt to overwrite files?"
    def compile

      p = Metc::Page.new

      p.generate(options[:force])
      p.generate_main(options[:force])

    end

    desc( "init", "initialize" )
    def init

      f = File.join( File.dirname(__FILE__), "../../db/site.sqlite3" )

      FileUtils.cp( f, Dir.pwd )

    end

    desc( "stage", "staging environment" )
    def stage

      config = File.join( File.dirname(__FILE__), "../../config/config.ru" )

      FileUtils.cp( config, Dir.pwd )

    end

    desc( "test", "testing" )
    def test

      p = Metc::Page.new
      p.generate_main
 
    end

    default_task :compile

  end

end

