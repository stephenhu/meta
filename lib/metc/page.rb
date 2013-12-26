module Metc

  class Page

    attr_reader :layout, :navbar, :catalog

    def initialize(dest=BASEDIR)

      @dest     = dest

      @catalog  = Metc::Catalog.new

      @layout = Tilt.new("layout.haml")
      @navbar = Tilt.new("navbar.haml")
      @col3   = Tilt.new("col3.haml")
      @col4   = Tilt.new("col4.haml")
      @col6   = Tilt.new("col6.haml")
      @col8a  = Tilt.new("col8a.haml")
      @col8b  = Tilt.new("col8b.haml")
      @col12  = Tilt.new("col12.haml")

    end

    def generate_row(contents)

      length = contents.length

      if length == 1
        return @col12.render( self, :contents => contents )
      elsif length == 2

        rng = Random.new(SEED)

        r = rng.rand(1..2)

        if r == 2
          return @col8a.render( self, :contents => contents )
        else
          return @col8b.render( self, :contents => contents )
        end

      elsif length == 3
        return @col4.render( self, :contents => contents )
      elsif length == 4
        return @col3.render( self, :contents => contents )
      end

    end

    def generate_main(overwrite=false)

      c = @catalog.get_recent(-1)

      length = c.length
      remain = length
      index  = 0

      doc = ""

      rng = Random.new(SEED)

      while remain != 0 do

        n = rng.rand(1..remain)

        r = generate_row(c[index..index+n-1])

        remain = remain - n
        index  = index + n

        doc = doc + r
        
      end

      html = @layout.render { doc }

      Metc::Filelib.create_file( html, INDEX, @dest, overwrite )

    end

    def generate(overwrite=false)

      contents = Metc::Filelib.get_contents
      exclude  = []

      contents.each do |c|

        if File.zero?(c)

          puts "skipped file #{c} - empty file".yellow
          exclude << c
          next

        end 

        html    = @layout.render { Tilt.new(c).render }

        Metc::Filelib.create_file( html, c, @dest, overwrite )

      end

      @catalog.check_contents( contents, exclude )

    end

  end

end

