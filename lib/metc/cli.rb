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

      contents = Metc::Filelib.get_contents

      contents.each do |c|
        p.generate(c)
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

