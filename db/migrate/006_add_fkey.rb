Sequel.migration do

  up do

    alter_table(:contents) do
      add_foreign_key :layout_id, :layouts
      add_foreign_key :navbar_id, :navbars
      add_foreign_key :page_id, :pages
      add_foreign_key :footer_id, :footers
    end

  end

  down do

    alter_table(:contents) do
      drop_foreign_key :layout_id
      drop_foreign_key :navbar_id
      drop_foreign_key :page_id
      drop_foreign_key :footer_id
    end

  end

end

