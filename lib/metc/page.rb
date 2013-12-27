module Metc

  class Page

    attr_reader :layout, :navbar, :catalog

    def initialize(dest=BASEDIR)

      @dest     = dest

      @catalog  = Metc::Catalog.new

      @layout = Tilt.new("layout.haml")
      @navbar = Tilt.new("navbar.haml")
      @col    = Tilt.new("col.haml")

    end

    def generate_row(contents)

      length = contents.length

      if length == 1
        contents[0][:col_classes] = "col-lg-12 box"
      elsif length == 2

        rng = Random.new(SEED)

        r = rng.rand(1..3)

        if r == 3
          contents[0][:col_classes] = "col-lg-6 box"
          contents[1][:col_classes] = "col-lg-6 box"
        elsif r == 2
          contents[0][:col_classes] = "col-lg-8 box"
          contents[1][:col_classes] = "col-lg-4 box"
        else
          contents[0][:col_classes] = "col-lg-4 box"
          contents[1][:col_classes] = "col-lg-8 box"
        end

      elsif length == 3
        contents[0][:col_classes] = "col-lg-4 box"
        contents[1][:col_classes] = "col-lg-4 box"
        contents[2][:col_classes] = "col-lg-4 box"
      else
        contents[0][:col_classes] = "col-lg-3 box"
        contents[1][:col_classes] = "col-lg-3 box"
        contents[2][:col_classes] = "col-lg-3 box"
        contents[3][:col_classes] = "col-lg-3 box"
      end

      return contents

    end

    def generate_main(overwrite=false)

      c = @catalog.get_recent(-1)

      length = c.length
      remain = length
      index  = 0

      rows = []

      rng = Random.new(SEED)

      while remain != 0 do

        n = rng.rand(1..remain)

        r = generate_row(c[index..index+n-1])

        remain = remain - n
        index  = index + n

        rows << r
        
      end

      doc   = @col.render( self, :rows => rows )

      html  = @layout.render { doc }

      Metc::Filelib.create_file( html, INDEX, @dest, overwrite )

    end

    def generate(overwrite=false)

      all = Metc::Filelib.get_contents

      all.each do |c|

        if File.zero?(c)

          puts "skipped file #{c} - empty file".yellow
          next

        end

        content = @catalog.check_content(c)

        content[:col_classes] = "col-lg-12 box"
        content[:summary]     = Tilt.new(c).render
        content[:link]        = File.basename( content[:path],
          File.extname(content[:path]) ) + HTMLEXT

        contents = []
        contents << content

        rows = []
        rows << contents

        r = @col.render( self, :rows => rows )

        html = @layout.render { r }
        
        Metc::Filelib.create_file( html, c, @dest, overwrite )

      end

    end

  end

end

