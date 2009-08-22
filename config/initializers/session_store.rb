# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_last_percent_session',
  :secret      => 'bfcb40572b604b4513b5541ef0e085ed62c1cc2f40d853001528cff320ddebef9769a2e852ad0f299230b79f05aaba4c9f664c874b85b9e6daac35baab613ee7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
