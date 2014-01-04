module Meta

  class Page

    attr_reader :catalog

    def initialize(dest=BASEDIR)

      @dest       = dest

      @catalog    = Meta::Catalog.new

      @templates  = Meta::Filelib.get_templates

      puts @templates

      @layout = Tilt.new("layout.haml") if @templates.include?("layout.haml")
      @navbar = Tilt.new("navbar.haml") if @templates.include?("navbar.haml")
      @index  = Tilt.new("index.haml")  if @templates.include?("index.haml")
      @page   = Tilt.new("page.haml")   if @templates.include?("page.haml")

      if @layout.nil?
        abort("layout.haml template missing, this file must be included".red)
      end
      #TODO: must include index and page as well

    end

    def generate_index(overwrite=false)

      contents = @catalog.get_recent(-1)

      doc = @index.render( self, :contents => contents )

      html = @layout.render { doc }

      Meta::Filelib.create_file( html, INDEX, @dest, overwrite )

    end

    def generate(overwrite=false)

      all = Meta::Filelib.get_contents

      all.each do |c|

        if File.zero?(c)

          puts "skipped file #{c} - empty file".yellow
          next

        end

        content = @catalog.check_content(c)

        content[:summary]     = Tilt.new(c).render
        content[:link]        = File.basename( content[:path],
          File.extname(content[:path]) ) + HTMLEXT

        p = @page.render( self, :content => content )

        html = @layout.render { p }
        
        Meta::Filelib.create_file( html, c, @dest, overwrite )

      end

    end

  end

end

