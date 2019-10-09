# frozen_string_literal: true

require 'securerandom'
require 'active_support/time'
require 'byebug'

class TokenMutator
  attr_reader :expire_hours

  SECURE_HEX_SIZE = 5

  def initialize(params)
    @expire_hours = params[:expire_hours].to_i
  end

  def self.find_time_by_token(token)
    return unless token[0] == 't'

    Time.at(token[2..token[1].to_i + 1].to_i(32))
  end

  def call
    if expire_hours.present?
      make_token_with_hex_time(expire_hours)
    else
      make_token
    end
  end

  private

  # token have not hex time if first symbol is num
  def make_token
    "#{rand(0..9)}#{SecureRandom.hex(SECURE_HEX_SIZE)}}"
  end

  # t - timing is present
  # and current secure hex counter
  def make_token_with_hex_time(expire_hours)
    hex_time = ((Time.now + expire_hours.hour).to_i).to_s(32)
    "t#{hex_time.size}#{hex_time}#{make_token}"
  end
end
