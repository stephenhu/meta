Sequel.migration do

  up do

    alter_table(:contents) do
      add_foreign_key :layout_id, :layouts
    end

  end

  down do

    alter_table(:contents) do
      drop_foreign_key :layout_id
    end

  end

end

