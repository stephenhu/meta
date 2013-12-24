Sequel.migration do

  up do

    drop_table(:templates)
    drop_table(:revisions)

  end

  down do

    create_table(:templates) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end
 
    create_table(:revisions) do
      primary_key   :id
      String        :revisionid, :null => false
      String        :previousid, :null => false
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end

  end

end

