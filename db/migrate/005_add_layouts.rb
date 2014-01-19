Sequel.migration do

  up do

    create_table(:resources) do
      primary_key   :id
      String        :name, :null => false, :unique => true
      String        :folder
      String        :comment
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end

    create_table(:templates) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
      foreign_key   :resource_id, :resources
    end

  end

  down do

    drop_table(:resources)
    drop_table(:templates)

  end

end

