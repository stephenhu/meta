Sequel.migration do

  up do

    self[:resources].insert(:name => "layout")
    self[:resources].insert(:name => "navbar")
    self[:resources].insert(:name => "page")
    self[:resources].insert(:name => "index")
    self[:resources].insert(:name => "footer")
       
  end

  down do

    self[:resources].where(:name => "layout").delete
    self[:resources].where(:name => "navbar").delete
    self[:resources].where(:name => "page").delete
    self[:resources].where(:name => "index").delete
    self[:resources].where(:name => "footer").delete

  end

end

