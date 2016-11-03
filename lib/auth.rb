# Ruby file to help encode and decode JSON Web Tokens

# Use jwt gem
require 'jwt'

# Custom Authorization class
module Auth

  # Use HS256 as hashing alg, set as class constant to use in .issue and .decode
  ALGORITHM = 'HS256'

  # Method to issue tokens
  def self.issue(payload)
    # Use encode method (from jwt gem) to generate a token
    JWT.encode(payload, ENV["super_secret_info"], ALGORITHM)
  end

  # Method to decode tokens
  def self.decode(token)
    # Use decode method (from jwt gem) to interpret a token
    JWT.decode(token, ENV["super_secret_info"], true, { algorithm: ALGORITHM }).first
  end
end
