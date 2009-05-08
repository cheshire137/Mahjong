# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mahjong_session',
  :secret      => '214a6f1befc3d7e827c80d8768fc80fbb578d53d9177e611ccce93010510e49c40cd5aa89edd48bf71063d3d2da4eba6a8cae4733bde24f1387d7127652e05a3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
