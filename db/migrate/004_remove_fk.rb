Sequel.migration do

  up do

    drop_column :contents, :template_id

  end

  down do

    add_column :contents, :template_id

  end

end

