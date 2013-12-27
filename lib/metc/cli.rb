module Metc

  class CLI < Thor
    include Thor::Actions

    desc "compile", "compile meta files" 
    method_option :output, :aliases => "-o", :type => :string,
      :required => false, :desc => "static file output directory"
    #method_option :exclude, :aliases => "-e", :type => :string,
    #  :required => false, :desc => "comma separated list"
    method_option :force, :aliases => "-f", :type => :boolean,
      :required => false, :desc => "don't prompt to overwrite files"
    def compile

      if options[:output].nil?
        dest = "."
      else
        dest = options[:output]
      end

      p = Metc::Page.new(dest)

      p.generate(options[:force])
      p.generate_main(options[:force])

    end

    desc "init", "initialize static metc project" 
    def init

      f = File.join( File.dirname(__FILE__), "../../db/site.sqlite3" )

      if File.exists?("site.sqlite3")

        puts "Warning: All index data will be lost!".red
        reply = agree("Database already exists, overwrite?".red) {
          |q| q.default = "n" }

        if reply
          FileUtils.cp( f, Dir.pwd )
          puts "Database re-initialized".green
        else
          puts "Database not initialized".red
        end

      else

        FileUtils.cp( f, Dir.pwd )
        puts "Database initialized".green

      end

    end

    desc "stage", "staging environment"
    def stage

      config = File.join( File.dirname(__FILE__), "../../config/config.ru" )

      if File.exists?("config.ru")
        puts "Environment has already been staged, no action taken.".yellow
      else

        FileUtils.cp( config, Dir.pwd )
        puts "Run 'rackup' to start testing.".green

      end

    end

    desc( "test", "testing" )
    def test

      p = Metc::Page.new
      p.generate_main
 
    end

    default_task :compile

  end

end

