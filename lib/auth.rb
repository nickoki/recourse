# Ruby file to help encode and decode JSON Web Tokens

# Use jwt gem
require 'jwt'

# Custom Authorization class
class Auth

  # Method to issue tokens
  def self.issue(payload)
    # Use encode method (from jwt gem) to generate a token
    JWT.encode(payload, auth_secret, ALGORITHM)
  end

  # Method to decode tokens
  def self.decode(token)
    # Use decode method (from jwt gem) to interpret a token
    JWT.decode(token, auth_secret, true, { algorithm: ALGORITHM }).first
  end

  def self.auth_secret
    ENV["AUTH_SECRET"]
  end
end
