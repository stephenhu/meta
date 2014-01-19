module Meta

  class Catalog

    attr_accessor :db, :resources

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

    def get_resource(template)

      dir = File.dirname(template)

      r = self.db[:resources].where(:folder => dir).first()

      if r.nil?
        return nil
      else
        return r[:id]
      end

    end

    def select_template(template)

      rs = self.db[:templates].join(:resources, :id => :resource_id).where(
        :name => template)

      choose do |menu|
       
        menu.prompt = "Choose #{template}: "
        rs.each do |r|
          menu.choice File.basename(r[:path]) do return r[:id] end
        end
       
      end
      
    end

    def sync_content(content)

      hash    = Digest::MD5.hexdigest(content)

      if content_exists?(content)
        revise_content( content, hash )
      else

        title   = ask "Please add a Title for #{content}? "
        layout  = select_template("layout")

        add_content( content, hash, title, layout )

      end

      rs    = self.db[:contents].where(:hash => hash).first()

      name  = self.db[:templates].where(:id => rs[:template_id]).first()[:path]

      rs[:layout] = name

      return rs

    end

    def add_content( file, title, hash, layout )

      self.db[:contents].insert(
        :title => title,
        :hash => hash,
        :path => file,
        :template_id => layout,
        :created_at => Time.now )

    end

    def revise_content( file, hash )

      content = self.db[:contents].where(:path => file).first

      tid = select_template("layout") if content[:template_id].nil?
        
      #puts self.db[:contents].where(:path => file).select(:title).first()[:title]
      self.db[:contents].where(:path => file).update(
        :hash => hash,
        #:title => title,
        :template_id => tid,
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
        :resource_id => get_resource(file),
        :path => file,
        :hash => hash )

    end

    def revise_template( file, hash )

      rs = self.db[:templates].where( :hash => hash, :path => file ).first

      if rs.empty?

        self.db[:templates].insert(
          :resource_id => get_resource(file),
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

