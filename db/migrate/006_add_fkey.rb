Sequel.migration do

  up do

    alter_table(:contents) do
      add_foreign_key :template_id, :templates
    end

  end

  down do

    alter_table(:contents) do
      drop_foreign_key :template_id
    end

  end

end

