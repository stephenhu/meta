module Metc

  class CLI < Thor
    include Thor::Actions

    desc( "compile", "compile meta files" )
    method_option :output, :type => :string, :required => false,
      :desc => "location of source meta files"
    method_option :exclude, :type => :string, :required => false,
      :desc => "comma separated list"
    def compile
      to_html( options[:exclude], options[:output] )
    end

    default_task :compile

    no_tasks do

      def check_exclusions(excludes_str)

        if excludes_str.nil?
          return EXCLUDES
        else

          user_excludes = excludes_str.split(",").each { |e| e.strip! }
          user_excludes = user_excludes + EXCLUDES
          user_excludes.uniq!
          return user_excludes

        end

      end

      def create_directory(name)

        unless name.nil?

          if File.directory?(name)
            puts "directory already exists"
          else
            FileUtils.mkdir_p(name)
            puts "directory #{name} created".green
          end

        end

      end

      def init_templates()
#TODO: allow customization, layout required, navbar and footer optional
        if File.exists?("layout.haml") and File.exists?("navbar.haml") and
          File.exists?("footer.haml")

          @layout = Tilt.new("layout.haml")
          @navbar = Tilt.new("navbar.haml")
          @footer = Tilt.new("footer.haml")

        else
          abort "layout.haml, navbar.haml, and footer.haml required".red
        end

      end

      def generate_filename( filename, dir )

        ext = File.extname(filename)

        if ext == MARKDOWN
          f = filename.chomp(MARKDOWN) + HTML
        else
          f = filename.chomp(HAML) + HTML
        end

        if dir.nil?
          return f
        else
          return dir + "/" + f
        end

      end

      def create_file( contents, filename )

        reply = true

        if File.exists?(filename)
          reply = yes?("file #{filename} exists, overwrite?")
        end

        if reply

          f = File.open( filename, "w" )
          f.write(contents)
          f.close

          puts "file #{filename} created".green

        end

      end

      def to_html( exclude, dir )

        exclusions = check_exclusions(exclude)

        templates = Dir.glob("*.haml") + Dir.glob("*.md")

        if templates.empty?
          abort "no source files found".red
        else

          init_templates

          create_directory(dir) unless dir.nil?

          templates.each do |h|

            next if exclusions.include?(h)

            html = @layout.render { Tilt.new(h).render }

            filename = generate_filename( h, dir )

            create_file( html, filename )

          end

        end
 
      end

    end

  end

end

