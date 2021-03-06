module Meta

  class Page

    attr_reader :catalog

    def initialize(dest=BASEDIR)

      @dest       = dest

      @catalog    = Meta::Catalog.new

      @layouts  = Meta::Filelib.get_templates(LAYOUTS)
      @navbars  = Meta::Filelib.get_templates(NAVBARS)
      @pages    = Meta::Filelib.get_templates(PAGES)
      @footers  = Meta::Filelib.get_templates(FOOTERS)

      unless @layouts.include?(LAYOUT)
        abort("layout.haml not found, #{LAYOUT}, #{INDEX}, and #{PAGE} must exist".red)
      end

      unless @pages.include?(INDEX)
        abort("index.haml not found, #{LAYOUT}, #{INDEX}, and #{PAGE} must exist".red)
      end

      unless @pages.include?(PAGE)
        abort("page.haml not found, #{LAYOUT}, #{INDEX}, #{PAGE} must exist".red)
      end

      templates  = @layouts | @pages
      templates |= @navbars unless @navbars.nil?
      templates |= @footers unless @footers.nil?

      @catalog.sync_templates(templates)

      @index    = Tilt.new(INDEX)
      @page     = Tilt.new(PAGE)
      @layout   = Tilt.new(LAYOUT)

    end

    def generate_index(overwrite=false)

      contents  = @catalog.get_recent(-1)

      stats     = @catalog.get_statistics

      doc       = @index.render( self, :contents => contents )

      html      = @layout.render( self, :stats => stats ) { doc }

      puts "If any content has been modified, index.html should be updated.".yellow

      Meta::Filelib.create_file( html, INDEX, HTMLEXT, @dest, overwrite )

    end

    def generate(overwrite=false)

      all = Meta::Filelib.get_contents

      stats   = @catalog.get_statistics

      all.each do |c|

        if File.zero?(c)

          puts "skipped file #{c} - empty file".yellow
          next

        end

        content = @catalog.sync_content(c)

        content[:summary]     = Tilt.new(c).render
        content[:link]        = File.basename( content[:path],
          File.extname(content[:path]) ) + HTMLEXT

        layout = @catalog.get_template( "layouts", content[:layout_id] )
        page   = @catalog.get_template( "pages", content[:page_id] )

        @mylayout = Tilt.new(layout)
        @mypage   = Tilt.new(page)

        p     = @mypage.render( self, :content => content )

        html  = @mylayout.render( self, :stats => stats ) { p }
        
        Meta::Filelib.create_file( html, c, HTMLEXT, @dest, overwrite )

      end

    end

  end

end

