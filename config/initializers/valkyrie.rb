# frozen_string_literal: true
require 'valkyrie'
Rails.application.config.to_prepare do

  Valkyrie::MetadataAdapter.register(
      Valkyrie::Persistence::Postgres::MetadataAdapter.new,
      :postgres
  )

  Valkyrie::MetadataAdapter.register(
      Valkyrie::Persistence::Solr::MetadataAdapter.new(
          connection: Blacklight.default_index.connection
      ), :solr
  )

  Valkyrie::MetadataAdapter.register(
      Valkyrie::Persistence::Fedora::MetadataAdapter.new(
          connection: ::Ldp::Client.new("http://localhost:8984/rest"),
          base_path: "dev",
          schema: Valkyrie::Persistence::Fedora::PermissiveSchema.new(title: RDF::URI("http://library.upenn.edu/pqc/ns/title"))
      ), :fedora
  )

  Valkyrie.config.resource_class_resolver = lambda do |resource_klass_name|
    Valkyrie::GenericWork
  end



end