require 'securerandom'
require 'active_support/time'
require 'byebug'

class TokenMutator
  attr_reader :expire_hours, :click_striker

  SECURE_HEX_SIZE = 5

  def initialize(params)
    @expire_hours = params[:expire_hours].to_i
    @click_striker = params[:click_striker].to_i
  end

  def self.find_time_by_token(token)
    return unless token[0] == 't'

    Time.at(token[2..token[1].to_i + 1].to_i(32))
  end

  def self.timing?(token)
    token[0] == 't'
  end

  def self.striker?(token)
    token[-1] == 's'
  end

  def call
    token = make_token
    token.prepend(time_stamp) if expire_hours.positive?
    token << 's' if click_striker.positive?

    token
  end

  private

  # token have not hex time if first symbol is num
  def make_token
    "#{rand(0..9)}#{SecureRandom.hex(SECURE_HEX_SIZE)}#{rand(0..9)}"
  end

  # t - timing is present
  # and current secure hex size
  def time_stamp
    hex_time = ((Time.now + expire_hours.hour).to_i).to_s(32)
    "t#{hex_time.size}#{hex_time}"
  end
end
