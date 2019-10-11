# frozen_string_literal: true

require_relative 'token_mutator'
require_relative 'body_mutator'

class MessageMutator
  attr_reader :mutated_params

  def initialize(params)
    # token with hex(32) time
    # encrypted AES body
    # expire_hours
    # click_striker
    @mutated_params = {token: TokenMutator.new(params).call,
                       body: BodyMutator.new(params).encrypted,
                       expire_hours: params[:expire_hours],
                       click_strike: params[:click_strike].to_i}
  end
end
