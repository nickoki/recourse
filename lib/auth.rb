# Ruby file to help encode and decode JSON Web Tokens

# Use jwt gem
require 'jwt'

# Custom Authorization class
class Auth

  # Use HS256 as hashing alg, set as class constant to use in .issue and .decode
  ALGORITHM = 'HS256'

  # Method to issue tokens
  def self.issue(payload)
    # Use encode method (from jwt gem) to generate a token
    JWT.encode(payload, Rails.application.secrets.secret_key_base, ALGORITHM)
  end

  # Method to decode tokens
  def self.decode(token)
    # Use decode method (from jwt gem) to interpret a token
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: ALGORITHM }).first
  end

  def self.auth_secret
    ENV["AUTH_SECRET"]
  end
end
