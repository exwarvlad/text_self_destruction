require 'dotenv/load'

ENV['RACK_ENV'] ||= 'test'
Dotenv.load('.env.development')

def decipher_message(encrypted_message)
  decipher = OpenSSL::Cipher::AES.new(128, :CBC)
  decipher.decrypt
  decipher.key = ENV['key'][0..15]
  decipher.iv = ENV['iv'][0..15]

  decipher.update(encrypted_message) + decipher.final
end