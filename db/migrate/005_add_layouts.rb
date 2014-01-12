Sequel.migration do

  up do

    create_table(:layouts) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end

    create_table(:navbars) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end

    create_table(:pages) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end

    create_table(:footers) do
      primary_key   :id
      String        :path, :null => false
      String        :hash, :unique => true
      Time          :created_at, :default => Time.now
      Time          :updated_at, :default => Time.now
    end


  end

  down do

    drop_table(:layouts)
    drop_table(:navbars)
    drop_table(:pages)
    drop_table(:footers)

  end

end

