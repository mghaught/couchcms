module CouchRestRails
  class Document < CouchRest::ExtendedDocument
    use_database COUCHDB_SERVER.default_database
    include Validatable
    # include CouchRest::Validation
    # include ActiveSupport::Callbacks
    
  end
end