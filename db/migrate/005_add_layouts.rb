Sequel.migration do

  up do

    create_table(:layouts) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end

  end

  down do

    drop_table(:layouts)

  end

end

