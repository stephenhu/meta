Sequel.migration do

  up do

    self[:resources].insert(:name => "layout",  :folder => "layouts")
    self[:resources].insert(:name => "navbar",  :folder => "navbars")
    self[:resources].insert(:name => "page",    :folder => "pages")
    self[:resources].insert(:name => "footer",  :folder => "footers")
       
  end

  down do

    self[:resources].where(:name => "layout").delete
    self[:resources].where(:name => "navbar").delete
    self[:resources].where(:name => "page").delete
    self[:resources].where(:name => "footer").delete

  end

end

