# frozen_string_literal: true

require 'openssl'
require 'dotenv/load'

class BodyMutator
  attr_reader :encrypted

  def initialize(params)
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.key = ENV['key'][0..15]
    cipher.iv = ENV['iv'][0..15]

    @encrypted = cipher.update(params[:body]) + cipher.final
  end
end
