Sequel.migration do

  up do

    add_column :contents, :picture, FalseClass 

  end

  down do

    drop_column :contents, :picture

  end

end

