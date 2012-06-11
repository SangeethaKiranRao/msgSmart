# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_DocTalkUSA_session',
  :secret      => 'd61d5d6e78250e93f35bf34d118e84998538d0302a4b3070a405dd2f1c6f75d88fcfa188e5c78bb1a228cb418f9f87648f06262cfd31de49398cbd14e4e19039'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
