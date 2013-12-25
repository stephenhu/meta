module Metc

  class CLI < Thor
    include Thor::Actions

    desc( "compile", "compile meta files" )
    method_option :output, :type => :string, :required => false,
      :desc => "location of source meta files"
    method_option :exclude, :type => :string, :required => false,
      :desc => "comma separated list"
    def compile

      p = Metc::Page.new

      p.generate()
      p.generate_main()

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

