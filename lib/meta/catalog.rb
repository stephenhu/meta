module Meta

  class Catalog

    attr_accessor :db

    def initialize

      self.db = Sequel.sqlite(Meta::DATASTORE)
      
    end

    def self.upgrade

      db = Sequel.sqlite(Meta::DATASTORE)

      Sequel::Migrator.run( db, File.join( File.dirname(__FILE__),
        "../../db/migrate" ) )

    end

    def get_statistics

      stats = Hash.new

      stats[:posts]       = self.db[:contents].count
      stats[:pictures]    = self.db[:contents].where(:picture => true).count

      return stats

    end

    def content_exists?(file)

      rs = self.db[:contents].where(:path => file).all

      if rs.empty?
        return false
      else
        return true
      end

    end

    def get_content(file)

      rs = self.db[:contents].where(:path => file).first

      return rs

    end

    def get_recent(count)

      if count < 0
        rs = self.db[:contents].order(Sequel.desc(:created_at)).all
      else
        rs = self.db[:contents].order(Sequel.desc(:created_at)).limit(
          count).all
      end

      rs.each do |r|
        content = Tilt.new(r[:path]).render

        content = "abc" if content.empty?
        
        r[:summary] = content
        r[:link] = File.basename( r[:path], File.extname(r[:path]) ) +
          HTMLEXT
        r[:picture] = false
      end

      return rs

    end

    def sync_content(content)

      hash    = Digest::MD5.hexdigest(content)

      if content_exists?(content)
        revise_content( content, hash )
      else
        title   = ask "Please add a Title for #{content}? "
        add_content( content, title, hash )
      end

      return self.db[:contents].where(:hash => hash).first()

    end

    def add_content( file, title, hash )

      self.db[:contents].insert(
        :title => title,
        :hash => hash,
        :path => file,
        :created_at => Time.now )

    end

    def revise_content( file, hash )

      #puts self.db[:contents].where(:path => file).select(:title).first()[:title]
      self.db[:contents].where(:path => file).update(
        :hash => hash,
        #:title => title,
        :updated_at => Time.now )

    end

    def update_content_title( file, title )

      self.db[:contents].where(:path => file).update(
        :title => title, :updated_at => Time.now )

    end

    def sync_templates(templates)

      templates.each do |t|

        hash = Digest::MD5.hexdigest(t)

        if template_exists?(t)

          revise_template( t, hash )

        else

          add_template( t, hash )

        end

      end

    end

    def add_template( file, hash )

      self.db[:templates].insert(
        :path => file,
        :hash => hash )

    end

    def revise_template( file, hash )

      rs = self.db[:templates].where( :hash => hash, :path => file ).first

      if rs.empty?

        self.db[:templates].insert(
          :path => file,
          :hash => hash )

      end

    end

    def template_exists?(file)

      rs = self.db[:templates].where(:path => file).all

      if rs.empty?
        return false
      else
        return true
      end

    end

    def template_revised?( path, hash )

      rs = self.db[:templates].where( :hash => hash, :path => path )

      if rs.nil?
        return true
      else
        return false
      end

    end

  end

end

