# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_couchpilot_session',
  :secret      => 'ac3fbad7ad7bd2be24a43a6090fe85943643d1bd5f076503cd5f27f50d0bd4f42a02ad55896b59c28543501cb033c9bed30aeeaaa6d43fb8c14b2f4f20cc0e06'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
