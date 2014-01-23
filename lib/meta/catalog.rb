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

    def get_template( template, id )

      rs = self.db[template.to_sym].where(:id => id).first

      if rs.nil?
        return nil
      else
        return rs[:path]
      end

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

      rs = self.db[template.to_sym].all

      return rs[0][:id] if rs.count == 1
      return nil if rs.empty?

      choose do |menu|
       
        menu.prompt = "Choose #{template}: "
        rs.each do |r|
          menu.choice File.basename(r[:path]) do return r[:id] end
        end
       
      end
      
    end

    def sync_content(content)

      hash = Digest::MD5.hexdigest(File.read(content))

      if content_exists?(content)
        revise_content( content, hash )
      else
        add_content( content, hash )
      end

      rs = self.db[:contents].where(:hash => hash).first

      return rs

    end

    def add_content( file, hash )

      title   = ask "Please add a Title for #{file}? "

      layout  = select_template("layouts")
      navbar  = select_template("navbars")
      # leave pages out for now, just default to page.haml
      #page    = select_template("pages")
      footer  = select_template("footers")

      self.db[:contents].insert(
        :title => title,
        :hash => hash,
        :path => file,
        :layout_id => layout,
        :navbar_id => navbar,
        :page_id => 1,
        :footer_id => footer,
        :created_at => Time.now )

    end

    def revise_content( file, hash )
      
      content = self.db[:contents].where(:path => file).first
      
      puts "Changes detected for #{file}".yellow if hash != content[:hash]

      if content[:layout_id].nil?
        # for legacy schema purposes
        puts "Select layout for #{file}:"
        lid = select_template("layouts")
      else
        lid = content[:layout_id]
      end

      self.db[:contents].where(:path => file).update(
        :hash => hash,
        :layout_id => lid,
        :page_id => 1,
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

      dir = File.dirname(file)

      self.db[dir.to_sym].insert(
        :path => file,
        :hash => hash )

    end

    def revise_template( file, hash )

      dir = File.dirname(file)

      rs = self.db[dir.to_sym].where( :hash => hash, :path => file ).first

      if rs.empty?

        self.db[dir.to_sym].insert(
          :path => file,
          :hash => hash )

      end

    end

    def template_exists?(file)

      dir = File.dirname(file)

      rs = self.db[dir.to_sym].where(:path => file).all

      if rs.empty?
        return false
      else
        return true
      end

    end

    def template_revised?( path, hash )

      dir = File.dirname(path)

      rs = self.db[dir.to_sym].where( :hash => hash, :path => path )

      if rs.nil?
        return true
      else
        return false
      end

    end

  end

end

