# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_savon_session',
  :secret      => '87f8b2f275ede3e56a75c3a7e21abb82a231b976438bf4055d4663a8e13e50b7b65dec12032f5b61a89fda6e11be20081ee36f8fe9d2ce95bbdb6a39b01f0dc5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
