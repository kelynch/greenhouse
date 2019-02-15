class GenericWork < ActiveFedora::Base 

  property :unique_identifier, predicate: ::RDF::URI.new('http://library.upenn.edu/pqc/ns/uniqueIdentifier'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

end
