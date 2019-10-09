# frozen_string_literal: true

require 'openssl'
require 'dotenv/load'

class BodyMutator
  attr_reader :encrypted

  def initialize(params)
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.key = ENV['key']
    cipher.iv = ENV['iv']

    @encrypted = cipher.update(params[:body]) + cipher.final
  end
end
