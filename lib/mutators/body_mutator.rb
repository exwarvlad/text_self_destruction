# frozen_string_literal: true

require 'openssl'
require 'dotenv/load'
require 'base64'

class BodyMutator
  attr_reader :encrypted

  def initialize(params)
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.key = ENV['key'][0..15]
    cipher.iv = ENV['iv'][0..15]

    @encrypted = BodyMutator.encode_utf(cipher.update(params[:body]) + cipher.final)
  end

  def self.encode_utf(encrypted)
    Base64.encode64(encrypted).encode('utf-8')
  end

  def self.encode_ascii(encoded)
    Base64.decode64 encoded.encode('ascii-8bit')
  end

  def self.decipher_message(encrypted_message)
    decipher = OpenSSL::Cipher::AES.new(128, :CBC)
    decipher.decrypt
    decipher.key = ENV['key'][0..15]
    decipher.iv = ENV['iv'][0..15]

    decipher.update(BodyMutator.encode_ascii(encrypted_message)) + decipher.final
  end
end
