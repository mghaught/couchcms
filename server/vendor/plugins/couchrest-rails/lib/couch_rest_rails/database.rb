module CouchRestRails
  module Database

    extend self

    def create(database)
      resp = []
      return  "Database '#{database}' doesn't exists" unless
        (database == "*" || File.exist?(File.join(RAILS_ROOT,
                                                  CouchRestRails.setup_path,
                                                  database)))

      # get list of available_databases in couch...
      existing_databases = COUCHDB_SERVER.databases
      # get all the model files
      Dir[File.join(RAILS_ROOT, CouchRestRails.setup_path,database)].each do |db|
        # check for a directory...
        if File::directory?( db )
          database_name =COUCHDB_CONFIG[:db_prefix] +  File.basename(db) +
            COUCHDB_CONFIG[:db_suffix]
          if existing_databases.include?(database_name)
            resp << "The CouchDB database '#{database_name}' already exists"
          else
            # create the database
            COUCHDB_SERVER.create_db(database_name)
            resp << "Created the CouchDB database '#{database_name}'"
            # create views on database
            resp << CouchRestRails::Views.push(File.basename(db),"*")
            # create lucene-searches
            resp << CouchRestRails::Lucene.push(File.basename(db),"*")
          end
        end
      end
      resp << "create complete"
      resp.join("\n")
    end

    def delete(database)
      resp = []
      return  "Database '#{database}' doesn't exists" unless
        (database == "*" || File.exist?(File.join(RAILS_ROOT,
                                                  CouchRestRails.setup_path,
                                                  database)))
      # get list of available_databases in couch...
      existing_databases = COUCHDB_SERVER.databases
      # get all the model files
      Dir[File.join(RAILS_ROOT, CouchRestRails.setup_path,database)].each do |db|
        # check for a directory...
        if File::directory?( db )
          database_name =COUCHDB_CONFIG[:db_prefix] +  File.basename(db) +
            COUCHDB_CONFIG[:db_suffix]
          if existing_databases.include?(database_name)
            CouchRest.delete "#{COUCHDB_CONFIG[:host_path]}/#{database_name}"
            resp << "Dropped CouchDB database '#{database_name}'"
          else
            resp << "The CouchDB database '#{database_name}' does not exist"
          end
        end
      end
      resp << "delete complete"
      resp.join("\n")
    end
  end
end
