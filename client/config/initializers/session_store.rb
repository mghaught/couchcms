# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_globeclient_session',
  :secret      => '47399da71cf714214d61f491caa7ba0a0a32a27ffaf6c2a69bae4bfdb25b2025d6744e309483650174fbac6c202850124027553e9086f070506d71fbaf25287f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
