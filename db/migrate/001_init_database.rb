Sequel.migration do

  up do

    create_table(:templates) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end

    create_table(:contents) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      String        :title, :null => false
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
      foreign_key   :template_id, :templates
    end

    create_table(:revisions) do
      primary_key   :id
      String        :revisionid, :null => false
      String        :previousid, :null => false
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end

  end

  down do

    drop_table(:templates)
    drop_table(:contents)
    drop_table(:revisions)

  end

end

