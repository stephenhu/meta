module Metc

  class Page

    attr_reader :layout, :navbar, :catalog

    def initialize()

      @catalog = Metc::Catalog.new

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
        return @col8a.render( self, :contents => contents )
      elsif length == 3
        return @col4.render( self, :contents => contents )
      elsif length == 4
        return @col3.render( self, :contents => contents )
      end

    end

    def generate_main()

      c = @catalog.get_recent(-1)

      length = c.length
      remain = length
      index  = 0

      doc = ""

      rng = Random.new(SEED)

      while remain != 0 do

        if remain > 4
          n = rng.rand(1..4)
        else
          n = remain
        end

        r = generate_row(c[index..index+n-1])

        remain = remain - n
        index  = index + n

        doc = doc + r
        
      end

      html = @layout.render { doc }

      Metc::Filelib.create_file( html, "index.html" )

    end

    def generate()

      contents = Metc::Filelib.get_contents

      contents.each do |c|

        next if File.zero?(c)

        html = @layout.render { Tilt.new(c).render }

        Metc::Filelib.create_file( html, c )

      end

      @catalog.check_contents(contents)

    end

  end

end

