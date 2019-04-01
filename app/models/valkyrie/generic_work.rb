module Valkyrie
  class GenericWork < Valkyrie::Resource

    attribute :title, Valkyrie::Types::String
    attribute :unique_identifier, Valkyrie::Types::String
    attribute :resource_type, Valkyrie::Types::String.optional
    attribute :alternate_identifiers, Valkyrie::Types::Array.optional

    def fedora_model
      ::GenericWork
    end

  end
end